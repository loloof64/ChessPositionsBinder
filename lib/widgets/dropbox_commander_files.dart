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
  final List<CommanderItem>? items;
  final String? pathText;
  final String? explorerLabel;
  final String? basePath;

  final Future<void> Function(String folderName) handleFolderSelection;
  final Future<void> Function() handleReload;
  final Future<void> Function(String folderName) handleCreateFolder;

  const CommanderFilesWidget({
    super.key,
    required this.explorerLabel,
    required this.pathText,
    required this.basePath,
    required this.items,
    required this.handleFolderSelection,
    required this.handleReload,
    required this.handleCreateFolder,
  });

  @override
  State<CommanderFilesWidget> createState() => _CommanderFilesWidgetState();
}

class _CommanderFilesWidgetState extends State<CommanderFilesWidget> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _newFolderNameController =
      TextEditingController();

  @override
  void dispose() {
    _newFolderNameController.dispose();
    _scrollController.dispose();
    super.dispose();
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
                t.pages.overall.buttons.cancel,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                t.pages.overall.buttons.ok,
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.explorerLabel != null)
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
                      Text(
                        widget.explorerLabel!,
                        softWrap: false,
                        style: const TextStyle(fontSize: 20),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: widget.handleReload,
                              icon: Icon(Icons.refresh),
                            ),
                            IconButton(
                              onPressed: _handleFolderCreation,
                              icon: Icon(Icons.folder),
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
            if (widget.items != null)
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(8.0),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: widget.items!.length,
                  itemBuilder: (context, index) {
                    final currentItem = widget.items![index];
                    final itemName = currentItem.simpleName;
                    final isFolder = currentItem.isFolder;
                    final isParentFolder = isFolder && itemName == parentFolder;
                    if (isParentFolder) {
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
