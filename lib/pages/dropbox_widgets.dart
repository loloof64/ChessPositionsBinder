import 'dart:io';

import 'package:chess_position_binder/i18n/strings.g.dart';
import 'package:chess_position_binder/widgets/dropbox_commander_files.dart';
import 'package:flutter/material.dart';

class ConnectedWidget extends StatelessWidget {
  final String? dropboxPath;
  final String? localExplorerBasePath;
  final bool isLocalSelectionMode;
  final bool isDropboxSelectionMode;
  final List<CommanderItem>? dropboxItems;
  final Future<void> Function(String folderName) handleDropboxFolderSelection;
  final Future<void> Function() handleDropboxContentReload;
  final Future<void> Function(String folderName) handleDropboxCreateFolder;
  final void Function() handleDropboxFilesTransferRequest;
  final void Function(bool isSelectionMode) handleDropboxSelectionModeToggling;
  final void Function(List<CommanderItem> selectedItems)
  handleDropboxDeleteItems;

  final String? localPath;
  final List<CommanderItem>? localItems;
  final Future<void> Function(String folderName) handleLocalFolderSelection;
  final Future<void> Function() handleLocalContentReload;
  final Future<void> Function(String folderName) handleLocalCreateFolder;
  final void Function() handleLocalFilesTransferRequest;
  final void Function(bool isSelectionMode) handleLocalSelectionModeToggling;
  final void Function(List<CommanderItem> selectedItems) handleLocalDeleteItems;

  const ConnectedWidget({
    super.key,
    required this.dropboxPath,
    required this.dropboxItems,
    required this.isDropboxSelectionMode,
    required this.handleDropboxFolderSelection,
    required this.handleDropboxContentReload,
    required this.handleDropboxCreateFolder,
    required this.handleDropboxFilesTransferRequest,
    required this.handleDropboxSelectionModeToggling,
    required this.handleDropboxDeleteItems,
    required this.localPath,
    required this.localExplorerBasePath,
    required this.localItems,
    required this.isLocalSelectionMode,
    required this.handleLocalFolderSelection,
    required this.handleLocalContentReload,
    required this.handleLocalCreateFolder,
    required this.handleLocalFilesTransferRequest,
    required this.handleLocalSelectionModeToggling,
    required this.handleLocalDeleteItems,
  });

  List<CommanderItem> _filteredLocalItems() {
    var result = localItems ?? [];

    if (localPath == null || localExplorerBasePath == null) return result;

    result = result.where((elt) {
      final isFlutterAssetsFolder =
          elt.simpleName == "flutter_assets" &&
          (localPath! == localExplorerBasePath!) &&
          Platform.isAndroid;
      return !isFlutterAssetsFolder;
    }).toList();

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    final usedLocalItems = _filteredLocalItems();

    final dropboxCommander = CommanderFilesWidget(
      areLocalFiles: false,
      isSelectionMode: isDropboxSelectionMode,
      basePath: null,
      explorerLabel: t.pages.dropbox.dropbox_explorer,
      items: dropboxItems,
      pathText: dropboxPath,
      handleFolderSelection: handleDropboxFolderSelection,
      handleReload: handleDropboxContentReload,
      handleCreateFolder: handleDropboxCreateFolder,
      handleFilesTransferRequest: handleDropboxFilesTransferRequest,
      handleSelectionModeToggling: handleDropboxSelectionModeToggling,
      handleDeleteItems: handleDropboxDeleteItems,
    );

    final localCommander = CommanderFilesWidget(
      areLocalFiles: true,
      isSelectionMode: isLocalSelectionMode,
      basePath: localExplorerBasePath,
      explorerLabel: t.pages.dropbox.local_explorer,
      items: usedLocalItems,
      pathText: localPath,
      handleFolderSelection: handleLocalFolderSelection,
      handleReload: handleLocalContentReload,
      handleCreateFolder: handleLocalCreateFolder,
      handleFilesTransferRequest: handleLocalFilesTransferRequest,
      handleSelectionModeToggling: handleLocalSelectionModeToggling,
      handleDeleteItems: handleLocalDeleteItems,
    );

    return SafeArea(
      child: orientation == Orientation.landscape
          ? Row(
              children: [
                Expanded(child: dropboxCommander),
                VerticalDivider(width: 1),
                Expanded(child: localCommander),
              ],
            )
          : Column(
              children: [
                Expanded(child: dropboxCommander),
                Divider(height: 1),
                Expanded(child: localCommander),
              ],
            ),
    );
  }
}

class UnconnectedWidget extends StatefulWidget {
  final TextEditingController codeController;
  final Future<void> Function() checkCode;
  final Future<void> Function() pasteFromClipboard;
  const UnconnectedWidget({
    super.key,
    required this.codeController,
    required this.checkCode,
    required this.pasteFromClipboard,
  });

  @override
  State<UnconnectedWidget> createState() => _UnconnectedWidgetState();
}

class _UnconnectedWidgetState extends State<UnconnectedWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(t.pages.dropbox.enter_auth_code),
        TextField(controller: widget.codeController),
        ElevatedButton(
          onPressed: widget.pasteFromClipboard,
          child: Text(t.misc.buttons.paste),
        ),
        ElevatedButton(
          onPressed: widget.checkCode,
          child: Text(t.misc.buttons.validate),
        ),
      ],
    );
  }
}
