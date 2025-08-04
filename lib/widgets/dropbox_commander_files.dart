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

  const CommanderFilesWidget({
    super.key,
    required this.explorerLabel,
    required this.pathText,
    required this.basePath,
    required this.items,
    required this.handleFolderSelection,
    required this.handleReload,
  });

  @override
  State<CommanderFilesWidget> createState() => _CommanderFilesWidgetState();
}

class _CommanderFilesWidgetState extends State<CommanderFilesWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                      IconButton(
                        onPressed: widget.handleReload,
                        icon: Icon(Icons.refresh),
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
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                      );
                    } else if (isFolder) {
                      return GestureDetector(
                        onTap: () => widget.handleFolderSelection(itemName),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                      );
                    } else {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
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
