import 'package:chess_position_binder/services/dropbox/dropbox_client.dart';

DropboxOAuth2Client client = DropboxOAuth2Client(
  redirectUri:
      "https://loloof64.github.io/ChessPositionsBinder/oauth2redirect.html",
  customUriScheme: "com.loloof64.chess_position_binder",
);
