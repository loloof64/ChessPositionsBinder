import 'package:chessground/chessground.dart';
import 'package:flutter/material.dart';
import 'package:dartchess/dartchess.dart' as chess;
import 'package:chess_position_binder/i18n/strings.g.dart';

const parentFolder = '@ParentFolder@';

class CommanderItem {
  final String simpleName;
  final String pgnContent;
  final bool isFolder;

  CommanderItem({
    required this.simpleName,
    required this.pgnContent,
    required this.isFolder,
  });

  @override
  String toString() {
    return "CommanderItem({$simpleName, $pgnContent, $isFolder})";
  }
}

class CommanderFilesWidget extends StatelessWidget {
  final List<CommanderItem>? items;
  final String? pathText;
  final String? explorerLabel;

  final Future<void> Function(String folderName) handleFolderSelection;

  const CommanderFilesWidget({
    super.key,
    required this.explorerLabel,
    required this.pathText,
    required this.items,
    required this.handleFolderSelection,
  });

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
            if (explorerLabel != null)
              Container(
                width: availableWidth,
                color: Colors.redAccent,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    explorerLabel!,
                    softWrap: false,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            if (items == null) Center(child: CircularProgressIndicator()),
            if (items != null && pathText != null)
              Container(
                width: availableWidth,
                color: Colors.amberAccent,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    pathText!,
                    softWrap: false,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            if (items != null)
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(8.0),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: items!.length,
                  itemBuilder: (context, index) {
                    final currentItem = items![index];
                    final itemName = currentItem.simpleName;
                    final itemPgn = currentItem.pgnContent;
                    final isFolder = currentItem.isFolder;
                    final isParentFolder = isFolder && itemName == parentFolder;
                    if (isParentFolder) {
                      return GestureDetector(
                        onTap: () => handleFolderSelection(parentFolder),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_back,
                              size: 50,
                              color: Colors.blueAccent,
                            ),
                          ],
                        ),
                      );
                    } else if (isFolder) {
                      return GestureDetector(
                        onTap: () => handleFolderSelection(itemName),
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
                      try {
                        final pgnGame = chess.PgnGame.parsePgn(itemPgn);
                        final position = chess.PgnGame.startingPosition(
                          pgnGame.headers,
                        );
                        final itemOrientation =
                            position.turn == chess.Side.white
                            ? chess.Side.white
                            : chess.Side.black;
                        final turnColor = position.turn == chess.Side.white
                            ? Colors.white
                            : Colors.black;
                        final turnSize = 18.0;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 4,
                          children: [
                            Container(
                              width: turnSize,
                              height: turnSize,
                              decoration: BoxDecoration(
                                color: turnColor,
                                border: BoxBorder.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                            ),
                            StaticChessboard(
                              pieceAssets: PieceSet.meridaAssets,
                              size: 25,
                              fen: position.fen,
                              orientation: itemOrientation,
                            ),
                            Text(itemName),
                          ],
                        );
                      } catch (e) {
                        debugPrint(e.toString());
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 4,
                          children: [
                            Icon(
                              Icons.insert_drive_file_rounded,
                              size: 25,
                              color: Colors.black45,
                            ),
                            Text(
                              t.pages.home.misc_errors
                                  .failed_reading_position_value(
                                    fileName: itemName,
                                  ),
                            ),
                          ],
                        );
                      }
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
