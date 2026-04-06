import 'package:chess_position_binder/models/synchronisation_items/dropbox_account.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dropbox_account_notifier.g.dart';

@Riverpod(keepAlive: true)
class DropboxAccountNotifier extends _$DropboxAccountNotifier {
  @override
  DropboxAccount? build() => null;

  void setAccount(DropboxAccount account) => state = account;

  DropboxAccount? getAccount() => state;

  void clear() => state = null;
}
