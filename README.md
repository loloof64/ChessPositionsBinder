# Chess position binder

[![Main Workflow](https://github.com/loloof64/ChessPositionsBinder/actions/workflows/main_workflow.yml/badge.svg)](https://github.com/loloof64/ChessPositionsBinder/actions/workflows/main_workflow.yml)

Store and classify your favorite chess positions.

You can also save/download them into/from your Dropbox account.

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

### Riverpod files generation

```bash
dart run build_runner watch -d
```

## Credits

### Tensorlow lite model

Using model from project [ChessCV](https://github.com/S1M0N38/chess-cv)
