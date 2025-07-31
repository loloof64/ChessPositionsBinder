import 'package:oauth2_client/oauth2_client.dart';

class DropboxOAuth2Client extends OAuth2Client {
  DropboxOAuth2Client({
    required super.redirectUri,
    required super.customUriScheme,
  }) : super(
         authorizeUrl: 'https://www.dropbox.com/oauth2/authorize',
         tokenUrl: 'https://api.dropboxapi.com/oauth2/token',
       );
}
