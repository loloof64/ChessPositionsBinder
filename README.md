# chess_position_binder

Store and classify your favorite chess positions.

## For developers

### Locales

In order to update locales, run `dart run slang` from your terminal.

### Dropbox

Add a file lib/services/dropbox/secrets.dart, and replace values accordingly

```dart
final identifier = '<YOUR_APP_DROPBOX_IDENTIFIER>';
final secret = '<YOUR_APP_DROPBOX_SECRET>';
```

Also you may want to follow [applink configurations](https://github.com/llfbandit/app_links/tree/master/doc) for each platform
