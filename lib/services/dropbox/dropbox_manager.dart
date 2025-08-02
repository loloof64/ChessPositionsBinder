import 'dart:async';
import 'dart:io';

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

class DropboxManager {
  oauth2.AuthorizationCodeGrant? _grant;
  late void Function(oauth2.Client) _gotClientCallback;

  DropboxManager({required Function(oauth2.Client) gotClientCallback}) {
    _gotClientCallback = gotClientCallback;
  }

  Future<void> startDropboxAuthProcess(
    void Function() onFailedLaunchingAuthPage,
  ) async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final pathSeparator = Platform.pathSeparator;
    final credentialsFile = File(
      "$appDocumentsDir${pathSeparator}credentials.json",
    );

    final exists = await credentialsFile.exists();
    if (exists) {
      final credentials = oauth2.Credentials.fromJson(
        await credentialsFile.readAsString(),
      );
      final client = oauth2.Client(
        credentials,
        identifier: identifier,
        secret: secret,
      );
      _gotClientCallback(client);
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
      _gotClientCallback(client);
      return TokenAuthResult.success;
    } catch (e) {
      debugPrint(e.toString());
      return TokenAuthResult.failed;
    }
  }
}
