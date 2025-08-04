import 'dart:async';
import 'dart:io';

import 'package:chess_position_binder/core/read_positions.dart';
import 'package:chess_position_binder/i18n/strings.g.dart';
import 'package:chess_position_binder/services/dropbox/dropbox_errors.dart';
import 'package:chess_position_binder/services/dropbox/dropbox_manager.dart';
import 'package:chess_position_binder/widgets/dropbox_commander_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:path_provider/path_provider.dart';

class DropboxPage extends StatefulWidget {
  const DropboxPage({super.key});

  @override
  State<DropboxPage> createState() => _DropboxPageState();
}

class _DropboxPageState extends State<DropboxPage> {
  bool _isConnected = false;
  String _displayName = "";
  String? _photoUrl;
  String? _freeSpace;
  String? _usedSpace;
  late DropboxManager _dropboxManager;
  final TextEditingController _codeController = TextEditingController(text: '');

  List<CommanderItem>? _dropboxItems;
  List<CommanderItem>? _localItems;
  String _dropboxPath = "/";
  String? _localPath;
  String? _documentsPath;

  @override
  void initState() {
    super.initState();
    _initializeLocalExplorer();
    _dropboxManager = DropboxManager(isReadyCallback: _onDropboxReady);
    _tryStartingDropbox();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _tryStartingDropbox() async {
    await _dropboxManager.startDropboxAuthProcess(
      _onFailedLaunchingDropboxAuthPage,
    );
  }

  Future<void> _onDropboxReady() async {
    setState(() {
      _isConnected = true;
    });
    await _getUserProfile();
    await _getUsageData();
    await _refreshDropboxContent();
  }

  Future<void> _getUserProfile() async {
    final userProfileResult = await _dropboxManager.getUserProfile();
    if (!context.mounted) return;
    switch (userProfileResult) {
      case Success():
        final displayName = userProfileResult.success.displayName;
        final photoUrl = userProfileResult.success.profilePhotoUrl;

        setState(() {
          _displayName = displayName;
          _photoUrl = photoUrl;
        });
        break;
      case Error():
        final error = userProfileResult.error;
        _handleError(error);
    }
  }

  Future<void> _getUsageData() async {
    final userUsageData = await _dropboxManager.getUserUsageData();
    if (!context.mounted) return;
    switch (userUsageData) {
      case Success():
        final freeSpace = userUsageData.success.freeSpace;
        final usedSpace = userUsageData.success.usedSpace;

        setState(() {
          _freeSpace = freeSpace;
          _usedSpace = usedSpace;
        });
        break;
      case Error():
        final error = userUsageData.error;
        _handleError(error);
    }
  }

  void _handleError(RequestError error) {
    final message = switch (error) {
      NoClientAvailable() => t.pages.dropbox.request_errors.no_client_available,
      BadInput() => t.pages.dropbox.request_errors.bad_request_input,
      AuthError() => t.pages.dropbox.request_errors.authentification,
      NoPermissionError() => t.pages.dropbox.request_errors.no_permission,
      EndpointError() => t.pages.dropbox.request_errors.endpoint,
      RateLimitError() => t.pages.dropbox.request_errors.rate_limit,
      ServerError() => t.pages.dropbox.request_errors.misc,
      ExpiredCredentials() =>
        t.pages.dropbox.request_errors.expired_credentials,
      _ => t.pages.dropbox.request_errors.unknown,
    };
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
    if (error is ExpiredCredentials) {
      setState(() {
        _isConnected = false;
      });
      _dropboxManager.restartAuthProcess(_onFailedLaunchingDropboxAuthPage);
    }
  }

  Future<void> _onFailedLaunchingDropboxAuthPage() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.pages.dropbox.failed_getting_auth_page)),
    );
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _checkCode() async {
    final token = _codeController.text;
    final authSuccess = await _dropboxManager.authenticateWithToken(token);
    if (authSuccess != TokenAuthResult.success) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.pages.dropbox.invalid_auth_code)),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData('text/plain');
    final clipboardText = clipboardData?.text ?? '';
    setState(() {
      _codeController.text = clipboardText;
    });
  }

  Future<void> _refreshDropboxContent() async {
    List<CommanderItem> items = [];
    final firstContent = await _dropboxManager.startListingFolder(_dropboxPath);
    if (!context.mounted) return;
    switch (firstContent) {
      case Success():
        final nextItems = firstContent.success.items;
        items.addAll(nextItems);
        break;
      case Error():
        final error = firstContent.error;
        _handleError(error);
        return;
    }
    bool hasMore = firstContent.success.hasMore;
    String cursor = firstContent.success.cursor;

    while (hasMore) {
      final nextContent = await _dropboxManager.goOnListingFolder(cursor);
      if (!context.mounted) return;
      switch (nextContent) {
        case Success():
          final nextItems = nextContent.success.items;
          items.addAll(nextItems);
          cursor = nextContent.success.cursor;
          hasMore = nextContent.success.hasMore;
          break;
        case Error():
          final error = nextContent.error;
          _handleError(error);
          return;
      }
    }

    if (_dropboxPath != '/') {
      items.add(CommanderItem(simpleName: parentFolder, isFolder: true));
    }

    final standardItems = _filterPgnFiles(items);
    final sortedStandardItems = _sortedItems(standardItems);

    setState(() {
      _dropboxItems = sortedStandardItems;
    });
  }

  List<CommanderItem> _filterPgnFiles(List<CommanderItem> items) {
    List<CommanderItem> resultItems = [];

    for (final currentItem in items) {
      if (currentItem.isFolder) {
        resultItems.add(
          CommanderItem(simpleName: currentItem.simpleName, isFolder: true),
        );
      } else {
        final name = currentItem.simpleName;
        if (name.endsWith('.pgn')) {
          resultItems.add(
            CommanderItem(simpleName: currentItem.simpleName, isFolder: false),
          );
        }
      }
    }

    return resultItems;
  }

  List<CommanderItem> _sortedItems(List<CommanderItem> items) {
    List<CommanderItem> result = items;
    result.sort((first, second) {
      if (first.isFolder && first.simpleName == parentFolder) return -1;
      if (second.isFolder && second.simpleName == parentFolder) return 1;
      if (first.isFolder && !second.isFolder) return -1;
      if (second.isFolder && !first.isFolder) return 1;
      return first.simpleName.toLowerCase().compareTo(
        second.simpleName.toLowerCase(),
      );
    });
    return result;
  }

  Future<void> _handleDropboxFolderSelection(String folderName) async {
    if (_dropboxItems == null) return;
    final isParentFolder = folderName == parentFolder;
    if (isParentFolder) {
      String parentPath;
      final currentSubFolderCounts =
          _dropboxPath.split("").where((elt) => elt == "/").length - 1;
      if (currentSubFolderCounts == 0) {
        parentPath = "/";
      } else {
        final parentPathElements = _dropboxPath.split("/");
        parentPathElements.removeLast();
        parentPath = parentPathElements.join("/");
      }
      setState(() {
        _dropboxItems = null;
        _dropboxPath = parentPath;
      });
      await _refreshDropboxContent();
      return;
    }
    final isAFolderOfCurrentPath = _dropboxItems!.contains(
      CommanderItem(simpleName: folderName, isFolder: true),
    );
    if (!isAFolderOfCurrentPath) return;

    final newPath = _dropboxPath == '/'
        ? "/$folderName"
        : "$_dropboxPath/$folderName";
    setState(() {
      _dropboxItems = null;
      _dropboxPath = newPath;
    });

    await _refreshDropboxContent();
  }

  Future<void> _handleDisconnection() async {
    await _dropboxManager.logout();
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(t.pages.dropbox.disconnected)));
    Navigator.of(context).pop();
  }

  Future<void> _initializeLocalExplorer() async {
    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final rootPath = documentsDirectory.path;

      setState(() {
        _localPath = rootPath;
        _documentsPath = rootPath;
      });

      await _refreshLocalExplorerContent();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.pages.dropbox.failed_reading_local_content)),
      );
    }
  }

  Future<void> _refreshLocalExplorerContent() async {
    if (_localPath == null) return;
    final currentLocalDirectory = Directory(_localPath!);
    final elements = await readElements(currentLocalDirectory);
    final localElements = elements.map((currentElement) {
      final path = currentElement.$1;
      final isFolder = currentElement.$3;
      final simpleName = path.split("/").last;
      return CommanderItem(simpleName: simpleName, isFolder: isFolder);
    }).toList();
    final isRootFolder = _localPath == _documentsPath;
    final allItems = isRootFolder
        ? localElements
        : [
            CommanderItem(simpleName: parentFolder, isFolder: true),
            ...localElements,
          ];
    setState(() {
      _localItems = allItems;
    });
  }

  Future<void> _handleLocalFolderSelection(String folderName) async {
    if (_localPath == null || _localItems == null) return;
    final isParentFolder = folderName == parentFolder;
    final currentDirectory = Directory(_localPath!);
    if (isParentFolder) {
      final parentDirectory = currentDirectory.parent;
      setState(() {
        _localPath = parentDirectory.path;
      });
      await _refreshLocalExplorerContent();
      return;
    }

    final isAFolderOfCurrentPath = _localItems!.contains(
      CommanderItem(simpleName: folderName, isFolder: true),
    );
    if (!isAFolderOfCurrentPath) return;

    try {
      final pathSeparator = Platform.pathSeparator;
      final newPath = "$_localPath$pathSeparator$folderName";
      setState(() {
        _localPath = newPath;
      });

      await _refreshLocalExplorerContent();
    } catch (e) {
      debugPrint(e.toString());
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.pages.home.misc_errors.failed_opening_folder)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Dropbox"),
            Row(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_displayName),
                    if (_freeSpace != null && _usedSpace != null)
                      Text(
                        "$_usedSpace / $_freeSpace",
                        style: TextStyle(fontSize: 14),
                      ),
                  ],
                ),
                if (_photoUrl != null)
                  ClipOval(
                    child: Image.network(
                      _photoUrl!,
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
                IconButton(
                  onPressed: _handleDisconnection,
                  icon: Icon(Icons.logout),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: _isConnected == false
            ? UnconnectedWidget(
                codeController: _codeController,
                checkCode: _checkCode,
                pasteFromClipboard: _pasteFromClipboard,
              )
            : ConnectedWidget(
                dropboxPath: _dropboxPath,
                dropboxItems: _dropboxItems,
                handleDropboxFolderSelection: (folderName) async =>
                    await _handleDropboxFolderSelection(folderName),
                localPath: _localPath,
                localItems: _localItems,
                handleLocalFolderSelection: (folderName) async =>
                    await _handleLocalFolderSelection(folderName),
              ),
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
          child: Text(t.pages.overall.buttons.paste),
        ),
        ElevatedButton(
          onPressed: widget.checkCode,
          child: Text(t.pages.overall.buttons.validate),
        ),
      ],
    );
  }
}

class ConnectedWidget extends StatelessWidget {
  final String? dropboxPath;
  final List<CommanderItem>? dropboxItems;
  final Future<void> Function(String folderName) handleDropboxFolderSelection;

  final String? localPath;
  final List<CommanderItem>? localItems;
  final Future<void> Function(String folderName) handleLocalFolderSelection;

  const ConnectedWidget({
    super.key,
    required this.dropboxPath,
    required this.dropboxItems,
    required this.handleDropboxFolderSelection,
    required this.localPath,
    required this.localItems,
    required this.handleLocalFolderSelection,
  });

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    final commander1 = CommanderFilesWidget(
      explorerLabel: t.pages.dropbox.dropbox_explorer,
      items: dropboxItems,
      pathText: dropboxPath,
      handleFolderSelection: handleDropboxFolderSelection,
    );

    final commander2 = CommanderFilesWidget(
      explorerLabel: t.pages.dropbox.local_explorer,
      items: localItems,
      pathText: localPath,
      handleFolderSelection: handleLocalFolderSelection,
    );

    return SafeArea(
      child: orientation == Orientation.landscape
          ? Row(
              children: [
                Expanded(child: commander1),
                VerticalDivider(width: 1),
                Expanded(child: commander2),
              ],
            )
          : Column(
              children: [
                Expanded(child: commander1),
                Divider(height: 1),
                Expanded(child: commander2),
              ],
            ),
    );
  }
}

/*
We only need to parse PGN headers,
so that's all we need to check.
*/
bool isPGNWithHeaders(String content) {
  // Normalize line endings and trim the content
  final normalized = content.replaceAll('\r\n', '\n').trim();

  // Check for presence of at least one valid PGN tag line: [TagName "Value"]
  final tagRegex = RegExp(r'^\[\w+\s+"[^"\n]*"\]$', multiLine: true);
  final tagMatches = tagRegex.allMatches(normalized);

  return tagMatches.isNotEmpty;
}
