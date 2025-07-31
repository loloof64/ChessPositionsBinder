import 'package:chess_position_binder/services/dropbox/dropbox_client.dart';
import 'package:chess_position_binder/services/dropbox/secrets.dart';
import 'package:oauth2_client/oauth2_helper.dart';

DropboxOAuth2Client client = DropboxOAuth2Client(
  redirectUri:
      "https://loloof64.github.io/ChessPositionsBinder/oauth2redirect.html",
  customUriScheme: "com.loloof64.chess_position_binder",
);

OAuth2Helper oauth2Helper = OAuth2Helper(
  client,
  grantType: OAuth2Helper.authorizationCode,
  clientId: appKey,
  clientSecret: appSecret,
  scopes: [
    'account_info.read',
    'files.metadata.read',
    'files.content.write',
    'files.content.read',
  ],
);
