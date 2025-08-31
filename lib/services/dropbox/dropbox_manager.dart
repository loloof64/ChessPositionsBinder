import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chess_position_binder/core/file_utils.dart';
import 'package:chess_position_binder/core/text_utils.dart';
import 'package:chess_position_binder/services/dropbox/dropbox_errors.dart';
import 'package:chess_position_binder/widgets/dropbox_commander_files.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:chess_position_binder/services/dropbox/secrets.dart';
import 'package:flutter/cupertino.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

final uploadLimitSizePerFile = 1024 * 1024 * 150; // 150Mb

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
  final int freeSpace;
  final int usedSpace;
  final String freeSpaceStr;
  final String usedSpaceStr;

  UserUsageData({
    required this.freeSpace,
    required this.usedSpace,
    required this.freeSpaceStr,
    required this.usedSpaceStr,
  });
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
      return Error(NoClientAvailable(null));
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
        isExpiredCredentialsError
            ? ExpiredCredentials(null)
            : UnknownError(null),
      );
    }
  }

  Future<Result<UserUsageData, RequestError>> getUserUsageData() async {
    oauth2.Client client;
    if (_client == null) {
      return Error(NoClientAvailable(null));
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

        final String freeSpaceStr = _convertToUnit(freeSpaceBytes);
        final String usedSpaceStr = _convertToUnit(usedSpaceBytes);

        return Success(
          UserUsageData(
            freeSpace: freeSpaceBytes,
            usedSpace: usedSpaceBytes,
            freeSpaceStr: freeSpaceStr,
            usedSpaceStr: usedSpaceStr,
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
        isExpiredCredentialsError
            ? ExpiredCredentials(null)
            : UnknownError(null),
      );
    }
  }

  Future<Result<FoldersRequestResult, RequestError>> startListingFolder(
    String path,
  ) async {
    oauth2.Client client;
    if (_client == null) {
      return Error(NoClientAvailable(null));
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
        isExpiredCredentialsError
            ? ExpiredCredentials(null)
            : UnknownError(null),
      );
    }
  }

  Future<Result<FoldersRequestResult, RequestError>> goOnListingFolder(
    String cursor,
  ) async {
    oauth2.Client client;
    if (_client == null) {
      return Error(NoClientAvailable(null));
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
        isExpiredCredentialsError
            ? ExpiredCredentials(null)
            : UnknownError(null),
      );
    }
  }

  Future<Result<(), RequestError>> createFolder(String path) async {
    oauth2.Client client;
    if (_client == null) {
      return Error(NoClientAvailable(null));
    }
    client = _client!;

    try {
      final response = await client.post(
        Uri.parse("https://api.dropboxapi.com/2/files/create_folder_v2"),
        body: jsonEncode({"autorename": true, "path": path}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return Success(());
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
        isExpiredCredentialsError
            ? ExpiredCredentials(null)
            : UnknownError(null),
      );
    }
  }

  /*
  If result is Ok, then the wrapped list contains the items for which it failed, if any.
  */
  Future<Result<List<CommanderItem>, RequestError>> deleteItems({
    required String currentPath,
    required List<CommanderItem> itemsToDelete,
  }) async {
    oauth2.Client client;
    if (_client == null) {
      return Error(NoClientAvailable(null));
    }
    client = _client!;

    List<CommanderItem> failedItems = [];

    final basePath = currentPath == "/" ? "" : currentPath;
    try {
      for (final currentItem in itemsToDelete) {
        final response = await client.post(
          Uri.parse("https://api.dropboxapi.com/2/files/delete_v2"),
          body: jsonEncode({"path": "$basePath/${currentItem.simpleName}"}),
          headers: {'Content-Type': 'application/json'},
        );
        if (response.statusCode != 200) {
          debugPrint(
            convertError(response.statusCode, response.body).toString(),
          );
          failedItems.add(currentItem);
        }
      }
      return Success(failedItems);
    } catch (e) {
      final message = e.toString();
      debugPrint(message);
      final isExpiredCredentialsError = message.contains(
        "credentials have expired",
      );
      return Error(
        isExpiredCredentialsError
            ? ExpiredCredentials(null)
            : UnknownError(null),
      );
    }
  }

  /*
  Upload files, ignore folders.
  If result is Ok, then returns a tuple : 
  1) a list that contains the items for which it failed, if any,
  2) a list of file items which are too big, if any
  */
  Future<Result<(List<CommanderItem>, List<CommanderItem>), RequestError>>
  uploadFiles({
    required String currentLocalPath,
    required String currentDropboxPath,
    required List<CommanderItem> itemsToUpload,
  }) async {
    oauth2.Client client;
    if (_client == null) {
      return Error(NoClientAvailable(null));
    }
    client = _client!;

    List<CommanderItem> failedItems = [];
    List<CommanderItem> filesTooBig = [];

    final pathSeparator = Platform.pathSeparator;
    final baseLocalPath = currentLocalPath == pathSeparator
        ? ""
        : currentLocalPath;
    final baseDropboxPath = currentDropboxPath == "/" ? "" : currentDropboxPath;
    try {
      for (final currentItem in itemsToUpload) {
        if (currentItem.isFolder) {
          continue;
        }
        final localFile = File(
          "$baseLocalPath$pathSeparator${currentItem.simpleName}",
        );
        final fileSize = await localFile.length();
        final tooBig = fileSize > uploadLimitSizePerFile;
        if (tooBig) {
          filesTooBig.add(currentItem);
          continue;
        }
        final fileBytes = await localFile.readAsBytes();
        final response = await client.post(
          Uri.parse("https://content.dropboxapi.com/2/files/upload"),
          body: fileBytes,
          headers: {
            'Content-Type': 'application/octet-stream',
            'Dropbox-API-Arg': jsonEncode({
              "autorename": true,
              "mode": "add",
              "mute": false,
              "path": "$baseDropboxPath/${currentItem.simpleName}",
              "strict_conflict": false,
            }),
          },
        );

        if (response.statusCode != 200) {
          debugPrint(
            convertError(response.statusCode, response.body).toString(),
          );
          failedItems.add(currentItem);
        }
      }
      return Success((failedItems, filesTooBig));
    } catch (e) {
      final message = e.toString();
      debugPrint(message);
      final isExpiredCredentialsError = message.contains(
        "credentials have expired",
      );
      return Error(
        isExpiredCredentialsError
            ? ExpiredCredentials(null)
            : UnknownError(null),
      );
    }
  }

  /*
  Download files, ignore folders.
  If result is Ok, then a list that contains the items for which it failed, if any.
  */
  Future<Result<List<CommanderItem>, RequestError>> downloadFiles({
    required String currentLocalPath,
    required String currentDropboxPath,
    required List<CommanderItem> itemsToDownload,
  }) async {
    oauth2.Client client;
    if (_client == null) {
      return Error(NoClientAvailable(null));
    }
    client = _client!;

    List<CommanderItem> failedItems = [];

    final pathSeparator = Platform.pathSeparator;
    final baseLocalPath = currentLocalPath == pathSeparator
        ? ""
        : currentLocalPath;

    try {
      for (final currentItem in itemsToDownload) {
        if (currentItem.isFolder) {
          continue;
        }

        String localPath =
            "$baseLocalPath$pathSeparator${currentItem.simpleName}";
        File localFile = File(localPath);
        while (await localFile.exists()) {
          localPath = await getNextPathCopyFor(localPath);
          localFile = File(localPath);
        }

        final fileToDownloadPath =
            "${currentDropboxPath == "/" ? "" : currentDropboxPath}/${currentItem.simpleName}";

        final response = await client.post(
          Uri.parse("https://content.dropboxapi.com/2/files/download"),
          headers: {
            "Dropbox-API-Arg": jsonEncode({"path": fileToDownloadPath}),
          },
        );

        if (response.statusCode == 200) {
          final fileContent = response.body;
          final isTextFile = isTextContent(fileContent);
          final isArchiveFile = jsonDecode(
            response.headers['Dropbox-API-Result']!,
          )['name'].endsWith('.zip');
          if (isTextFile) {
            await localFile.create();
            await localFile.writeAsString(fileContent);
          } else if (isArchiveFile) {
          } else {
            debugPrint("Not a text|zip file : ${currentItem.simpleName}");
            failedItems.add(currentItem);
          }
        } else {
          return Error(convertError(response.statusCode, response.body));
        }
      }
      return Success(failedItems);
    } catch (e) {
      final message = e.toString();
      debugPrint(message);
      final isExpiredCredentialsError = message.contains(
        "credentials have expired",
      );
      return Error(
        isExpiredCredentialsError
            ? ExpiredCredentials(null)
            : UnknownError(null),
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
    try {
      // delete stored credentials
      await _credentialsFile?.delete();
    } catch (e) {
      debugPrint("Could not delete credentials file.");
    }
    // restart auth process
    await startDropboxAuthProcess(onFailedLaunchingAuthPage);
  }

  Future<Result<(), RequestError>> logout() async {
    oauth2.Client client;
    if (_client == null) {
      return Error(NoClientAvailable(null));
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
        isExpiredCredentialsError
            ? ExpiredCredentials(null)
            : UnknownError(null),
      );
    }
  }
}
