import 'dart:io';

import 'package:chess_position_binder/models/synchronisation_items/sync_state.dart';
import 'package:chess_position_binder/providers/dropbox_login_provider.dart';
import 'package:chess_position_binder/utils/constants.dart';
import 'package:chess_position_binder/utils/dropbox_api_service.dart';
import 'package:chess_position_binder/utils/sync_engine.dart';
import 'package:chess_position_binder/utils/sync_manifest_service.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_provider.g.dart';

@Riverpod(keepAlive: true)
class Sync extends _$Sync {
  @override
  SyncState build() => const SyncState();

  Future<void> sync() async {
    if (state.status == SyncStatus.syncing) return;

    state = const SyncState(status: SyncStatus.syncing);

    try {
      final loginNotifier = ref.read(dropboxLoginProvider.notifier);
      final accessToken = await loginNotifier.getAccessToken();

      if (accessToken == null) {
        state = const SyncState(
          status: SyncStatus.error,
          errorMessage: 'Not logged in',
        );
        return;
      }

      final appSupportDir = await getApplicationSupportDirectory();
      final positionsDir = Directory(
        p.join(appSupportDir.path, positionsRootFolderName),
      );

      // Ensure local positions directory exists
      if (!await positionsDir.exists()) {
        await positionsDir.create(recursive: true);
      }

      final manifestService = SyncManifestService(appSupportDir: appSupportDir);
      final previousManifest = await manifestService.load();

      final api = DropboxApiService(accessToken);
      final engine = SyncEngine(
        api: api,
        localPositionsDir: positionsDir,
        previousManifest: previousManifest,
        onProgress: (total, completed) {
          state = SyncState(
            status: SyncStatus.syncing,
            totalActions: total,
            completedActions: completed,
          );
        },
      );

      final newManifest = await engine.sync();
      await manifestService.save(newManifest);

      state = const SyncState(status: SyncStatus.success);
    } catch (e, st) {
      debugPrint('Sync failed: $e\n$st');
      state = SyncState(status: SyncStatus.error, errorMessage: e.toString());
    }
  }
}
