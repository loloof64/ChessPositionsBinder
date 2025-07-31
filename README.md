# Chess position binder

Store and classify your favorite chess positions.

## For developers

### Locales

In order to update locales, run `dart run slang` from your terminal.

### For dropbox

#### Code

Add a file lib/services/dropbox/secrets.dart and replace secrets accordingly

```dart
final appKey = "<YOUR_DROPBOX_APP_ID>";
final appSecret = "<YOUR_DROPBOX_APP_SECRET>";
```

#### Settings in Dropbox console

In your app settings on Dropbox for developpers

- add your redirect uri and adjust file services/dropbox/dropbox_manager.dart accordingly, as well as custom android scheme in AndroidManifest.xml
- add the scopes
  - account_info.read
  - files.metadata.read
  - files.content.write
  - files.content.read

### For IOS

You may check [setting for Oauth2_client](https://pub.dev/packages/oauth2_client#ios)
