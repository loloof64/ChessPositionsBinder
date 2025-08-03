import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chess_position_binder/services/dropbox/dropbox_errors.dart';
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
    if (await canLaunchUrl(authorizationUrl)) {
      await launchUrl(authorizationUrl);
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

  String _convertToUnit(int bytesStorage) {
    if (bytesStorage < 1024) {
      return "$bytesStorage o";
    } else if (bytesStorage < 1024 * 1024) {
      return "${(bytesStorage / 1024).toStringAsFixed(0)}Ko";
    } else if (bytesStorage < 1024 * 1024 * 1024) {
      return "${(bytesStorage / (1024 * 1024)).toStringAsFixed(0)}Mo";
    } else if (bytesStorage < 1024 * 1024 * 1024 * 1024) {
      return "${(bytesStorage / (1024 * 1024 * 1024)).toStringAsFixed(0)}Go";
    } else {
      return "${(bytesStorage / (1024 * 1024 * 1024 * 1024)).toStringAsFixed(0)}To";
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
}
