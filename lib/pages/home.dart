import 'dart:io';

import 'package:chess_position_binder/core/read_positions.dart';
import 'package:chess_position_binder/pages/position_editor.dart';
import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart' as chess;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Directory? _currentDirectory;
  Future<List<(String, String, bool)>> _contentFuture = Future.value([]);

  @override
  void initState() {
    super.initState();
    _setupCurrentDirectory().then((_) => _reloadContent());
  }

  Future<void> _reloadContent() async {
    setState(() {
      _contentFuture = readElements(_currentDirectory!);
    });
  }

  Future<void> _setupCurrentDirectory() async {
    _currentDirectory = await getApplicationDocumentsDirectory();
    _contentFuture = readElements(_currentDirectory!);
  }

  Future<void> _purposeCreatePosition() async {
    final result = await Navigator.of(context).push<(String, String)?>(
      MaterialPageRoute(
        builder: (context) {
          return PositionEditorPage(
            initialFen: chess.Chess.initial.fen,
            editingExistingFile: false,
          );
        },
      ),
    );
    if (result == null) {
      return;
    }

    final (pgn, selectedName) = result;

    final savedFile = File("${_currentDirectory!.path}/$selectedName");
    await savedFile.writeAsString(pgn);

    _reloadContent();
  }

  Future<void> _purposeEditPosition(String path) async {
    try {
      final pgnContent = await File(path).readAsString();
      final chessGame = chess.PgnGame.parsePgn(pgnContent);
      final initialFen = chessGame.headers["FEN"];
      if (initialFen == null) {
        throw Exception("FEN not found in PGN");
      }
      if (!context.mounted) {
        return;
      }
      final result = await Navigator.of(context).push<(String, String)?>(
        MaterialPageRoute(
          builder: (context) {
            return PositionEditorPage(
              initialFen: initialFen,
              editingExistingFile: true,
            );
          },
        ),
      );
      if (result == null) {
        return;
      }

      final (newPgn, _) = result;
      final savedFile = File(path);
      await savedFile.writeAsString(newPgn);

      _reloadContent();
    } catch (e) {
      debugPrint(e.toString());
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to edit position")));
    }
  }

  Future<void> _purposeDeletePosition(String path) async {
    final name = path.split("/").last;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete position ?"),
          content: Text("Are you sure you want to delete position $name ?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                _deletePosition(path);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePosition(String path) async {
    try {
      final savedFile = File(path);
      await savedFile.delete();
      _reloadContent();
    } catch (e) {
      debugPrint(e.toString());
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to delete position")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final width = MediaQuery.of(context).size.width;
    final boardSize = isPortrait ? width * 0.4 : width * 0.28;
    final content = FutureBuilder<List<(String, String, bool)>>(
      future: _contentFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final allItems = snapshot.data!;
          return allItems.isEmpty
              ? const Text("No item")
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final currentItem = snapshot.data![index];
                      final itemPath = currentItem.$1;
                      final itemName = itemPath.split('/').last;
                      final itemPgn = currentItem.$2;
                      final isFolder = currentItem.$3;
                      if (isFolder) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 2,
                          children: [
                            Icon(
                              Icons.folder,
                              size: 50,
                              color: Colors.amberAccent,
                            ),
                            Text(itemName),
                          ],
                        );
                      } else {
                        final pgnGame = chess.PgnGame.parsePgn(itemPgn);
                        final position = chess.PgnGame.startingPosition(
                          pgnGame.headers,
                        );
                        final itemOrientation =
                            position.turn == chess.Side.white
                            ? chess.Side.white
                            : chess.Side.black;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: StaticChessboard(
                                pieceAssets: PieceSet.meridaAssets,
                                size: boardSize,
                                fen: position.fen,
                                orientation: itemOrientation,
                              ),
                            ),
                            Text(itemName),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () =>
                                      _purposeEditPosition(itemPath),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () =>
                                      _purposeDeletePosition(itemPath),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    },
                  ),
                );
        } else if (snapshot.hasError) {
          return Icon(Icons.error, color: Colors.red);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Main page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.insert_drive_file_outlined),
            onPressed: () {
              _purposeCreatePosition();
            },
          ),
          IconButton(onPressed: _reloadContent, icon: Icon(Icons.refresh)),
        ],
      ),
      body: Center(child: content),
    );
  }
}
