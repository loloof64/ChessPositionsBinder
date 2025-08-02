import 'dart:async';
import 'dart:io';

import 'package:chess_position_binder/services/dropbox/secrets.dart';
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

Future<void> startDropboxAuthProcess(
  void Function(oauth2.Client) gotClientCallback,
  void Function() failedGettingClientCallback,
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
    gotClientCallback(client);
    return;
  }

  final grant = oauth2.AuthorizationCodeGrant(
    identifier,
    authorizationEndpoint,
    tokenEndpoint,
    secret: secret,
  );

  final authorizationUrl = grant.getAuthorizationUrl(redirectUrl);
  if (await canLaunchUrl(authorizationUrl)) {
    await launchUrl(authorizationUrl);
    return;
  }
  failedGettingClientCallback();
  return;
}
