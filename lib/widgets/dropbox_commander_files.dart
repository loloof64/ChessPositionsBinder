import 'dart:io';

import 'package:chess_position_binder/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:equatable/equatable.dart';

const parentFolder = '@ParentFolder@';

class CommanderItem extends Equatable {
  final String simpleName;
  final bool isFolder;

  const CommanderItem({required this.simpleName, required this.isFolder});

  @override
  String toString() {
    return "CommanderItem({$simpleName, $isFolder})";
  }

  @override
  List<Object> get props => [simpleName, isFolder];
}

class CommanderFilesWidget extends StatefulWidget {
  final bool areLocalFiles;
  final bool isSelectionMode;
  final List<CommanderItem>? items;
  final String? pathText;
  final String? explorerLabel;
  final String? basePath;

  final Future<void> Function(String folderName) handleFolderSelection;
  final Future<void> Function() handleReload;
  final Future<void> Function(String folderName) handleCreateFolder;
  final void Function() handleFilesTransferRequest;
  final void Function(bool isSelectionMode) handleSelectionModeToggling;
  final void Function(List<CommanderItem> selectedItems) handleDeleteItems;

  const CommanderFilesWidget({
    super.key,
    required this.areLocalFiles,
    required this.isSelectionMode,
    required this.explorerLabel,
    required this.pathText,
    required this.basePath,
    required this.items,
    required this.handleFolderSelection,
    required this.handleReload,
    required this.handleCreateFolder,
    required this.handleFilesTransferRequest,
    required this.handleSelectionModeToggling,
    required this.handleDeleteItems,
  });

  @override
  State<CommanderFilesWidget> createState() => _CommanderFilesWidgetState();
}

class _CommanderFilesWidgetState extends State<CommanderFilesWidget> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _newFolderNameController =
      TextEditingController();
  final Map<CommanderItem, bool> _selectedItems = <CommanderItem, bool>{};

  @override
  void dispose() {
    _newFolderNameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<CommanderItem> _filteredLocalItems() {
    var result = widget.items ?? [];

    if (!widget.areLocalFiles) return result;
    if (widget.pathText == null || widget.basePath == null) return result;

    result = result.where((elt) {
      final isFlutterAssetsFolder =
          elt.simpleName == "flutter_assets" &&
          (widget.pathText! == widget.basePath!) &&
          Platform.isAndroid;
      return !isFlutterAssetsFolder;
    }).toList();

    return result;
  }

  void _onToggleItemSelection(CommanderItem item) {
    final currentState = _selectedItems[item];
    if (currentState == null) {
      setState(() {
        _selectedItems[item] = true;
      });
    } else {
      setState(() {
        _selectedItems[item] = !currentState;
      });
    }
  }

  void _handleFolderCreation() {
    setState(() {
      _newFolderNameController.text = '';
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(t.widgets.commander.new_folder.title),
          content: TextField(
            controller: _newFolderNameController,
            decoration: InputDecoration(
              hintText: t.widgets.commander.new_folder.name_placeholder,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                t.misc.buttons.cancel,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                t.misc.buttons.ok,
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                widget.handleCreateFolder(_newFolderNameController.text.trim());
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _purposeConfirmDeletion() async {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.widgets.commander.no_item_selected)),
      );
      return;
    }
    final hasConfirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(t.widgets.commander.delete_items.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 4,
            children: [
              Text(t.widgets.commander.delete_items.message),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue.shade300, width: 1),
                ),
                constraints: BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ..._selectedItems.entries.map((entry) {
                        final currentItem = entry.key;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("*"),
                            Text(currentItem.simpleName),
                            Text(
                              "(${currentItem.isFolder ? t.misc.folder : t.misc.file})",
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                t.misc.buttons.cancel,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(
                t.misc.buttons.ok,
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () async {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (hasConfirmed != true) return;

    final itemsToDelete = _selectedItems.keys.toList();
    widget.handleDeleteItems(itemsToDelete);
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredLocalItems();
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.explorerLabel != null)
              // Title bar
              Container(
                width: availableWidth,
                color: Colors.redAccent,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // Explorer type
                      Text(
                        widget.explorerLabel!,
                        softWrap: false,
                        style: const TextStyle(fontSize: 20),
                      ),
                      // Icon buttons
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (!widget.isSelectionMode)
                              IconButton(
                                onPressed: widget.handleReload,
                                icon: Icon(Icons.refresh),
                              ),
                            if (!widget.isSelectionMode)
                              IconButton(
                                onPressed: _handleFolderCreation,
                                icon: Icon(Icons.folder),
                              ),
                            if (widget.isSelectionMode)
                              IconButton(
                                onPressed: widget.handleFilesTransferRequest,
                                icon: Icon(
                                  widget.areLocalFiles
                                      ? Icons.upload
                                      : Icons.download,
                                ),
                              ),
                            if (widget.isSelectionMode)
                              IconButton(
                                onPressed: _purposeConfirmDeletion,
                                icon: Icon(Icons.delete),
                              ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectedItems.clear();
                                });
                                widget.handleSelectionModeToggling(
                                  !widget.isSelectionMode,
                                );
                              },
                              icon: Icon(Icons.check_box_rounded),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (widget.items == null)
              Center(child: CircularProgressIndicator()),
            if (widget.items != null && widget.pathText != null)
              Container(
                width: availableWidth,
                color: Colors.amberAccent,
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.basePath == null
                            ? widget.pathText!
                            : widget.pathText!.replaceAll(
                                widget.basePath!,
                                t.pages.home.misc.base_directory,
                              ),
                        softWrap: false,
                        overflow: TextOverflow.visible,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            if (items.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(8.0),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final currentItem = items[index];
                    final itemName = currentItem.simpleName;
                    final isFolder = currentItem.isFolder;
                    final isParentFolder = isFolder && itemName == parentFolder;
                    if (widget.isSelectionMode) {
                      return isParentFolder
                          ? Container(
                              color: Colors.transparent,
                              width: double.infinity,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_back,
                                    size: 25,
                                    color: Colors.blueAccent,
                                  ),
                                ],
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                _onToggleItemSelection(currentItem);
                              },
                              child: Container(
                                width: double.infinity,
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  spacing: 2,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Checkbox(
                                        value:
                                            _selectedItems[currentItem] == true,
                                        onChanged: (newValue) {
                                          _onToggleItemSelection(currentItem);
                                        },
                                      ),
                                    ),
                                    Icon(
                                      isFolder
                                          ? Icons.folder
                                          : Ionicons.document_text,
                                      size: 25,
                                      color: isFolder
                                          ? Colors.amberAccent
                                          : Colors.blueAccent,
                                    ),
                                    Text(itemName),
                                  ],
                                ),
                              ),
                            );
                    } else if (isParentFolder) {
                      return GestureDetector(
                        onTap: () => widget.handleFolderSelection(parentFolder),
                        child: Container(
                          color: Colors.transparent,
                          width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                size: 25,
                                color: Colors.blueAccent,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (isFolder) {
                      return GestureDetector(
                        onTap: () => widget.handleFolderSelection(itemName),
                        child: Container(
                          width: double.infinity,
                          color: Colors.transparent,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 2,
                            children: [
                              Icon(
                                Icons.folder,
                                size: 25,
                                color: Colors.amberAccent,
                              ),
                              Text(itemName),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        width: double.infinity,
                        color: Colors.transparent,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 4,
                          children: [
                            Icon(
                              Ionicons.document_text,
                              size: 25,
                              color: Colors.blueAccent,
                            ),
                            Text(itemName),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
