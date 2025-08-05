import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chess_position_binder/services/dropbox/dropbox_errors.dart';
import 'package:chess_position_binder/widgets/dropbox_commander_files.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:chess_position_binder/services/dropbox/secrets.dart';
import 'package:flutter/cupertino.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

final authorizationEndpoint = Uri.parse(
  'https://www.dropbox.com/oauth2/authorize',
);
final tokenEndpoint = Uri.parse('https://api.dropboxapi.com/oauth2/token');

final redirectUrl = Uri.parse(
  'https://loloof64.github.io/ChessPositionsBinder/oauth2_code.html',
);

enum TokenAuthResult { noGrantYet, failed, success }

class UserProfile {
  final String displayName;
  final String? profilePhotoUrl;

  UserProfile({required this.displayName, required this.profilePhotoUrl});
}

class UserUsageData {
  final String freeSpace;
  final String usedSpace;

  UserUsageData({required this.freeSpace, required this.usedSpace});
}

class FoldersRequestResult {
  final List<CommanderItem> items;
  final String cursor;
  final bool hasMore;

  FoldersRequestResult({
    required this.items,
    required this.cursor,
    required this.hasMore,
  });
}

class DropboxManager {
  oauth2.AuthorizationCodeGrant? _grant;
  File? _credentialsFile;
  oauth2.Client? _client;
  late void Function() _isReadyCallback;

  DropboxManager({required void Function() isReadyCallback}) {
    _isReadyCallback = isReadyCallback;
  }

  bool isConnected() => _client != null;

  Future<void> startDropboxAuthProcess(
    void Function() onFailedLaunchingAuthPage,
  ) async {
    final Directory appSupportDir = await getApplicationSupportDirectory();
    await appSupportDir.create();
    final pathSeparator = Platform.pathSeparator;
    final fileName = 'credentials.json';
    _credentialsFile = File("${appSupportDir.path}$pathSeparator$fileName");

    final exists = await _credentialsFile?.exists();
    if (exists == true) {
      final credentials = oauth2.Credentials.fromJson(
        await _credentialsFile!.readAsString(),
      );
      final client = oauth2.Client(
        credentials,
        identifier: identifier,
        secret: secret,
      );
      _client = client;
      _isReadyCallback();
      return;
    }

    _grant = oauth2.AuthorizationCodeGrant(
      identifier,
      authorizationEndpoint,
      tokenEndpoint,
      secret: secret,
    );

    final authorizationUrl = _grant!.getAuthorizationUrl(redirectUrl);
    final uriWithForceReauthentification = authorizationUrl.replace(
      queryParameters: {
        ...authorizationUrl.queryParameters,
        'force_reauthentication': "true",
      },
    );
    if (await canLaunchUrl(uriWithForceReauthentification)) {
      await launchUrl(uriWithForceReauthentification);
      return;
    }

    onFailedLaunchingAuthPage();
    return;
  }

  Future<TokenAuthResult> authenticateWithToken(String token) async {
    if (_grant == null) {
      return TokenAuthResult.noGrantYet;
    }
    try {
      final client = await _grant!.handleAuthorizationCode(token);
      await _credentialsFile?.create();
      await _credentialsFile?.writeAsString(client.credentials.toJson());
      _client = client;
      _isReadyCallback();
      return TokenAuthResult.success;
    } catch (e) {
      debugPrint(e.toString());
      return TokenAuthResult.failed;
    }
  }

  Future<Result<UserProfile, RequestError>> getUserProfile() async {
    oauth2.Client client;
    if (_client == null) {
      return Error(NoClientAvailable());
    }
    client = _client!;

    try {
      final response = await client.post(
        Uri.parse("https://api.dropboxapi.com/2/users/get_current_account"),
      );
      if (response.statusCode == 200) {
        final body = response.body;
        final bodyJson = jsonDecode(body);

        final displayName = bodyJson["name"]["display_name"];
        final profilePhotoUrl = bodyJson["profile_photo_url"];

        return Success(
          UserProfile(
            displayName: displayName,
            profilePhotoUrl: profilePhotoUrl,
          ),
        );
      } else {
        return Error(convertError(response.statusCode, response.body));
      }
    } catch (e) {
      final message = e.toString();
      debugPrint(message);
      final isExpiredCredentialsError = message.contains(
        "credentials have expired",
      );
      return Error(
        isExpiredCredentialsError ? ExpiredCredentials() : UnknownError(),
      );
    }
  }

  Future<Result<UserUsageData, RequestError>> getUserUsageData() async {
    oauth2.Client client;
    if (_client == null) {
      return Error(NoClientAvailable());
    }
    client = _client!;

    try {
      final response = await client.post(
        Uri.parse("https://api.dropboxapi.com/2/users/get_space_usage"),
      );

      if (response.statusCode == 200) {
        final body = response.body;
        final bodyJson = jsonDecode(body);

        final int freeSpaceBytes = bodyJson["allocation"]["allocated"];
        final int usedSpaceBytes = bodyJson["used"];

        final String freeSpace = _convertToUnit(freeSpaceBytes);
        final String usedSpace = _convertToUnit(usedSpaceBytes);

        return Success(
          UserUsageData(freeSpace: freeSpace, usedSpace: usedSpace),
        );
      } else {
        return Error(convertError(response.statusCode, response.body));
      }
    } catch (e) {
      final message = e.toString();
      debugPrint(message);
      final isExpiredCredentialsError = message.contains(
        "credentials have expired",
      );
      return Error(
        isExpiredCredentialsError ? ExpiredCredentials() : UnknownError(),
      );
    }
  }

  Future<Result<FoldersRequestResult, RequestError>> startListingFolder(
    String path,
  ) async {
    oauth2.Client client;
    if (_client == null) {
      return Error(NoClientAvailable());
    }
    client = _client!;

    try {
      final response = await client.post(
        Uri.parse("https://api.dropboxapi.com/2/files/list_folder"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "include_deleted": false,
          "include_has_explicit_shared_members": false,
          "include_media_info": false,
          "include_mounted_folders": true,
          "include_non_downloadable_files": false,
          "path": path == "/" ? "" : path,
          "recursive": false,
        }),
      );

      if (response.statusCode == 200) {
        final body = response.body;
        final bodyJson = jsonDecode(body);

        final entries = bodyJson["entries"] as List<dynamic>;
        final String cursor = bodyJson["cursor"];
        final bool hasMore = bodyJson["has_more"];

        final items = entries.map((currentEntry) {
          return CommanderItem(
            simpleName: currentEntry["name"],
            isFolder: currentEntry[".tag"] == "folder",
          );
        }).toList();

        return Success(
          FoldersRequestResult(cursor: cursor, items: items, hasMore: hasMore),
        );
      } else {
        return Error(convertError(response.statusCode, response.body));
      }
    } catch (e) {
      final message = e.toString();
      debugPrint(message);
      final isExpiredCredentialsError = message.contains(
        "credentials have expired",
      );
      return Error(
        isExpiredCredentialsError ? ExpiredCredentials() : UnknownError(),
      );
    }
  }

  Future<Result<FoldersRequestResult, RequestError>> goOnListingFolder(
    String cursor,
  ) async {
    oauth2.Client client;
    if (_client == null) {
      return Error(NoClientAvailable());
    }
    client = _client!;

    try {
      final response = await client.post(
        Uri.parse("https://api.dropboxapi.com/2/files/list_folder/continue"),
        body: jsonEncode({"cursor": cursor}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final body = response.body;
        final bodyJson = jsonDecode(body);

        final entries = bodyJson["entries"] as List<dynamic>;
        final String cursor = bodyJson["cursor"];
        final bool hasMore = bodyJson["has_more"];
        final bool isFolder = bodyJson[".tag"] == "folder";

        final items = entries.map((currentEntry) {
          return CommanderItem(
            simpleName: currentEntry["name"],
            isFolder: isFolder,
          );
        }).toList();

        return Success(
          FoldersRequestResult(cursor: cursor, items: items, hasMore: hasMore),
        );
      } else {
        return Error(convertError(response.statusCode, response.body));
      }
    } catch (e) {
      final message = e.toString();
      debugPrint(message);
      final isExpiredCredentialsError = message.contains(
        "credentials have expired",
      );
      return Error(
        isExpiredCredentialsError ? ExpiredCredentials() : UnknownError(),
      );
    }
  }

  Future<Result<String, RequestError>> getRawItemContent(String path) async {
    oauth2.Client client;
    if (_client == null) {
      return Error(NoClientAvailable());
    }
    client = _client!;

    try {
      final response = await client.post(
        Uri.parse("https://content.dropboxapi.com/2/files/download"),
        headers: {
          "Dropbox-API-Arg": jsonEncode({"path": path == "/" ? "" : path}),
        },
      );

      if (response.statusCode == 200) {
        final fileContent = response.body;
        final isTextFile = isTextContent(fileContent);
        if (isTextFile) {
          return Success(fileContent);
        } else {
          return Error(NotATextFile());
        }
      } else {
        return Error(convertError(response.statusCode, response.body));
      }
    } catch (e) {
      final message = e.toString();
      debugPrint(message);
      final isExpiredCredentialsError = message.contains(
        "credentials have expired",
      );
      return Error(
        isExpiredCredentialsError ? ExpiredCredentials() : UnknownError(),
      );
    }
  }

  String _convertToUnit(int bytesStorage) {
    if (bytesStorage < 1024) {
      return "$bytesStorage o";
    } else if (bytesStorage < 1024 * 1024) {
      return "${(bytesStorage / 1024).toStringAsFixed(2)}Ko";
    } else if (bytesStorage < 1024 * 1024 * 1024) {
      return "${(bytesStorage / (1024 * 1024)).toStringAsFixed(2)}Mo";
    } else if (bytesStorage < 1024 * 1024 * 1024 * 1024) {
      return "${(bytesStorage / (1024 * 1024 * 1024)).toStringAsFixed(2)}Go";
    } else {
      return "${(bytesStorage / (1024 * 1024 * 1024 * 1024)).toStringAsFixed(2)}To";
    }
  }

  Future<void> restartAuthProcess(
    void Function() onFailedLaunchingAuthPage,
  ) async {
    // delete stored credentials
    await _credentialsFile?.delete();

    // restart auth process
    await startDropboxAuthProcess(onFailedLaunchingAuthPage);
  }

  Future<Result<(), RequestError>> logout() async {
    oauth2.Client client;
    if (_client == null) {
      return Error(NoClientAvailable());
    }
    client = _client!;

    try {
      await client.post(
        Uri.parse("https://api.dropboxapi.com/2/auth/token/revoke"),
      );

      // delete stored credentials
      await _credentialsFile?.delete();

      return Success(());
    } catch (e) {
      final message = e.toString();
      debugPrint(message);
      final isExpiredCredentialsError = message.contains(
        "credentials have expired",
      );
      return Error(
        isExpiredCredentialsError ? ExpiredCredentials() : UnknownError(),
      );
    }
  }
}

bool isTextContent(String content) {
  for (final rune in content.runes) {
    if (
    // Keep  Tab, LF, CR
    (rune < 32 && rune != 9 && rune != 10 && rune != 13) ||
        rune == 127 || // DEL
        (rune >= 128 && rune <= 159) || // extended control caracters
        rune >
            255 // above Latin-1
            ) {
      return false;
    }
  }
  return true;
}
