import 'dart:async';
import 'dart:io';

import 'package:chess_position_binder/core/read_positions.dart';
import 'package:chess_position_binder/i18n/strings.g.dart';
import 'package:chess_position_binder/pages/dropbox_widgets.dart';
import 'package:chess_position_binder/services/dropbox/dropbox_errors.dart';
import 'package:chess_position_binder/services/dropbox/dropbox_manager.dart';
import 'package:chess_position_binder/widgets/dropbox_commander_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:path_provider/path_provider.dart';

enum GroupedOperation { deletion, upload }

class DropboxPage extends StatefulWidget {
  const DropboxPage({super.key});

  @override
  State<DropboxPage> createState() => _DropboxPageState();
}

class _DropboxPageState extends State<DropboxPage> {
  bool _isConnected = false;
  String _displayName = "";
  String? _photoUrl;
  int? _usedSpace;
  int? _freeSpace;
  String? _freeSpaceStr;
  String? _usedSpaceStr;
  late DropboxManager _dropboxManager;
  final TextEditingController _codeController = TextEditingController(text: '');

  List<CommanderItem>? _dropboxItems;
  List<CommanderItem>? _localItems;
  final List<CommanderItem> _dropboxSelectedItems = [];
  final List<CommanderItem> _localSelectedItems = [];
  bool _isDropboxSelectionMode = false;
  bool _isLocalSelectionMode = false;
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
        final freeSpaceStr = userUsageData.success.freeSpaceStr;
        final usedSpaceStr = userUsageData.success.usedSpaceStr;

        setState(() {
          _freeSpace = freeSpace;
          _usedSpace = usedSpace;
          _freeSpaceStr = freeSpaceStr;
          _usedSpaceStr = usedSpaceStr;
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
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.pages.dropbox.failed_getting_auth_page)),
    );
    Navigator.of(context).pop();
  }

  Future<void> _checkCode() async {
    final token = _codeController.text;
    final authSuccess = await _dropboxManager.authenticateWithToken(token);
    if (authSuccess != TokenAuthResult.success) {
      if (!mounted) return;
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
    if (!mounted) return;
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
      if (!mounted) return;
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
      final path = currentElement.name;
      final isFolder = currentElement.isFolder;
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
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.pages.home.misc_errors.failed_opening_folder)),
      );
    }
  }

  Future<void> _handleDropboxFolderCreation(String folderName) async {
    setState(() {
      _dropboxItems = null;
    });
    final path = _dropboxPath == '/'
        ? "/$folderName"
        : "$_dropboxPath/$folderName";
    try {
      final result = await _dropboxManager.createFolder(path);
      switch (result) {
        case Success():
          await _refreshDropboxContent();
          break;
        case Error():
          final error = result.error;
          _handleError(error);
      }
    } catch (e) {
      debugPrint(e.toString());
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.pages.home.create_folder_errors.creation_error),
        ),
      );
    }
  }

  Future<void> _handleLocalFolderCreation(String folderName) async {
    String path = "$_localPath${Platform.pathSeparator}$folderName";
    bool alreadyExists = true;
    int copyRef = 0;

    try {
      do {
        final directory = Directory(path);
        if (await directory.exists()) {
          copyRef += 1;
          path = "$_localPath${Platform.pathSeparator}$folderName ($copyRef)";
        } else {
          break;
        }
      } while (alreadyExists);
      final directory = Directory(path);
      await directory.create();
      await _refreshLocalExplorerContent();
    } catch (e) {
      debugPrint(e.toString());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.pages.home.create_folder_errors.creation_error),
        ),
      );
    }
  }

  Future<void> _purposeDownloadDropboxFiles(
    List<CommanderItem>? itemsToUpload,
  ) async {}

  Future<void> _purposeUploadLocalFiles(
    List<CommanderItem>? itemsToUpload,
  ) async {
    if (_dropboxItems == null ||
        itemsToUpload == null ||
        _localPath == null ||
        itemsToUpload.isEmpty) {
      return;
    }

    setState(() {
      _isDropboxSelectionMode = false;
    });

    try {
      final result = await _dropboxManager.uploadFiles(
        currentDropboxPath: _dropboxPath,
        currentLocalPath: _localPath!,
        itemsToUpload: itemsToUpload,
      );
      switch (result) {
        case Success():
          final failedItems = result.success.$1;
          final hadFolders = result.success.$2;
          if (hadFolders) {
            await _showFilteredFoldersDialog();
          }
          if (failedItems.isNotEmpty) {
            await _showFailedDialog(
              operation: GroupedOperation.upload,
              failureItems: failedItems,
            );
          }
          await _refreshDropboxContent();
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(t.pages.dropbox.upload_done)));
          break;
        case Error():
          final error = result.error;
          _handleError(error);
      }
    } catch (e) {
      debugPrint(e.toString());
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.pages.home.create_folder_errors.creation_error),
        ),
      );
    }
  }

  Future<void> _showFilteredFoldersDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(t.pages.dropbox.skipped_folders),
          actions: [
            TextButton(
              child: Text(
                t.misc.buttons.ok,
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _onDropboxItemsDeletionRequest(
    List<CommanderItem> itemsToDelete,
  ) async {
    if (_dropboxItems == null || itemsToDelete.isEmpty) return;

    setState(() {
      _isDropboxSelectionMode = false;
    });

    try {
      final result = await _dropboxManager.deleteItems(
        currentPath: _dropboxPath,
        itemsToDelete: itemsToDelete,
      );
      switch (result) {
        case Success():
          final failedItems = result.success;
          if (failedItems.isNotEmpty) {
            await _showFailedDialog(
              operation: GroupedOperation.deletion,
              failureItems: failedItems,
            );
          }
          await _refreshDropboxContent();
          break;
        case Error():
          final error = result.error;
          _handleError(error);
      }
    } catch (e) {
      debugPrint(e.toString());
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.pages.home.create_folder_errors.creation_error),
        ),
      );
    }
  }

  Future<void> _showFailedDialog({
    required GroupedOperation operation,
    required List<CommanderItem> failureItems,
  }) async {
    final title = switch (operation) {
      GroupedOperation.deletion => t.pages.dropbox.failed_deleting_items,
      GroupedOperation.upload => t.pages.dropbox.failed_uploading_items,
    };
    final lines = failureItems.map((elt) {
      return Text(
        "* ${elt.simpleName} (${elt.isFolder ? t.misc.folder : t.misc.file})",
      );
    }).toList();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Container(
            decoration: BoxDecoration(
              border: BoxBorder.all(color: Colors.blue.shade300, width: 1),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 1,
                children: lines,
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                t.misc.buttons.ok,
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _onLocalItemsDeletionRequest(
    List<CommanderItem> itemsToDelete,
  ) async {
    setState(() {
      _isLocalSelectionMode = false;
    });
    List<CommanderItem> failedItems = [];
    for (final currentItem in itemsToDelete) {
      String path =
          "$_localPath${Platform.pathSeparator}${currentItem.simpleName}";
      final concreteCurrentItem = File(path);
      try {
        await concreteCurrentItem.delete(recursive: true);
      } catch (e) {
        debugPrint(e.toString());
        failedItems.add(currentItem);
      }
    }

    if (failedItems.isNotEmpty) {
      await _showFailedDialog(
        operation: GroupedOperation.deletion,
        failureItems: failedItems,
      );
    }
    await _refreshLocalExplorerContent();
  }

  void _onDropboxToggleItemSelection(CommanderItem item) {
    if (_dropboxItems == null) return;
    setState(() {
      if (_dropboxSelectedItems.contains(item)) {
        _dropboxSelectedItems.remove(item);
      } else {
        _dropboxSelectedItems.add(item);
      }
    });
  }

  void _onLocalToggleItemSelection(CommanderItem item) {
    if (_localItems == null) return;
    setState(() {
      if (_localSelectedItems.contains(item)) {
        _localSelectedItems.remove(item);
      } else {
        _localSelectedItems.add(item);
      }
    });
  }

  void _onDropboxAllItemsSelectionToggling(bool newState) {
    if (_dropboxItems == null) {
      return;
    }
    for (final currentItem in _dropboxItems!) {
      final isParentFolderItem =
          (currentItem.isFolder) && (currentItem.simpleName == parentFolder);
      if (isParentFolderItem) continue;
      setState(() {
        if (newState && !_dropboxSelectedItems.contains(currentItem)) {
          _dropboxSelectedItems.add(currentItem);
        } else if (!newState && _dropboxSelectedItems.contains(currentItem)) {
          _dropboxSelectedItems.remove(currentItem);
        }
      });
    }
  }

  void _onLocalAllItemsSelectionToggling(bool newState) {
    if (_localItems == null || _localPath == null || _documentsPath == null) {
      return;
    }
    for (final currentItem in _filteredLocalItems()) {
      final isParentFolderItem =
          (currentItem.isFolder) && (currentItem.simpleName == parentFolder);
      if (isParentFolderItem) continue;
      setState(() {
        if (newState && !_localSelectedItems.contains(currentItem)) {
          _localSelectedItems.add(currentItem);
        } else if (!newState && _localSelectedItems.contains(currentItem)) {
          _localSelectedItems.remove(currentItem);
        }
      });
    }
  }

  List<CommanderItem> _filteredLocalItems() {
    var result = _localItems ?? [];

    if (_localPath == null || _documentsPath == null) return result;

    result = result.where((elt) {
      final isFlutterAssetsFolder =
          elt.simpleName == "flutter_assets" &&
          (_localPath! == _documentsPath!) &&
          Platform.isAndroid;
      return !isFlutterAssetsFolder;
    }).toList();

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final filteredLocalItems = _filteredLocalItems();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5,
          children: [
            const Text("Dropbox", style: TextStyle(fontSize: 16)),
            Row(
              spacing: 5,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_displayName, style: TextStyle(fontSize: 14)),
                    if (_freeSpaceStr != null && _usedSpaceStr != null)
                      Text(
                        "$_usedSpaceStr / $_freeSpaceStr",
                        style: TextStyle(fontSize: 14),
                      ),
                    if (_freeSpace != null && _usedSpace != null)
                      SizedBox(
                        width: 100,
                        height: 10,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.black54,
                          color: Colors.blueAccent,
                          value:
                              _usedSpace!.toDouble() / _freeSpace!.toDouble(),
                        ),
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
                isDropboxSelectionMode: _isDropboxSelectionMode,
                isLocalSelectionMode: _isLocalSelectionMode,
                localExplorerBasePath: _documentsPath,
                dropboxPath: _dropboxPath,
                dropboxItems: _dropboxItems,
                dropboxSelectedItems: _dropboxSelectedItems,
                handleDropboxFolderSelection: (folderName) async =>
                    await _handleDropboxFolderSelection(folderName),
                handleDropboxContentReload: () async {
                  setState(() {
                    _dropboxItems = null;
                  });
                  await _refreshDropboxContent();
                },
                handleDropboxCreateFolder: (folderName) async =>
                    await _handleDropboxFolderCreation(folderName),
                handleDropboxFilesTransferRequest: _purposeDownloadDropboxFiles,
                handleDropboxSelectionModeToggling: (isSelectionMode) {
                  setState(() {
                    _isDropboxSelectionMode = isSelectionMode;
                  });
                },
                handleDropboxDeleteItems: _onDropboxItemsDeletionRequest,
                handleDropboxToggleItemSelection: _onDropboxToggleItemSelection,
                handleDropboxAllItemsSelectionSetting:
                    _onDropboxAllItemsSelectionToggling,
                localPath: _localPath,
                localItems: filteredLocalItems,
                localSelectedItems: _localSelectedItems,
                handleLocalFolderSelection: (folderName) async =>
                    await _handleLocalFolderSelection(folderName),
                handleLocalContentReload: () async {
                  setState(() {
                    _localItems = null;
                  });
                  await _refreshLocalExplorerContent();
                },
                handleLocalCreateFolder: (folderName) async =>
                    await _handleLocalFolderCreation(folderName),
                handleLocalFilesTransferRequest: _purposeUploadLocalFiles,
                handleLocalSelectionModeToggling: (isSelectionMode) {
                  setState(() {
                    _isLocalSelectionMode = isSelectionMode;
                  });
                },
                handleLocalDeleteItems: _onLocalItemsDeletionRequest,
                handleLocalToggleItemSelection: _onLocalToggleItemSelection,
                handleLocalAllItemsSelectionSetting:
                    _onLocalAllItemsSelectionToggling,
              ),
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
