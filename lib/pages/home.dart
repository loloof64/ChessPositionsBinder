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
  Future<List<(String, String)>> _contentFuture = Future.value([]);

  @override
  void initState() {
    super.initState();
    _setupCurrentDirectory();
  }

  Future<void> _reloadContent() async {
    setState(() {
      _contentFuture = readPositions(_currentDirectory!);
    });
  }

  Future<void> _setupCurrentDirectory() async {
    _currentDirectory = await getApplicationDocumentsDirectory();
    _contentFuture = readPositions(_currentDirectory!);
  }

  Future<void> _purposeCreatePosition() async {
    final result = await Navigator.of(context).push<(String, String)?>(
      MaterialPageRoute(
        builder: (context) {
          return PositionEditorPage(initialFen: chess.Chess.initial.fen);
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

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final width = MediaQuery.of(context).size.width;
    final boardSize = isPortrait ? width * 0.4 : width * 0.28;
    final content = FutureBuilder<List<(String, String)>>(
      future: _contentFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final allItems = snapshot.data!;
          return allItems.isEmpty
              ? const Text("No item")
              : ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final currentItem = snapshot.data![index];
                    final itemName = currentItem.$1;
                    final itemPgn = currentItem.$2;
                    final pgnGame = chess.PgnGame.parsePgn(itemPgn);
                    final position = chess.PgnGame.startingPosition(
                      pgnGame.headers,
                    );
                    final itemOrientation = position.turn == chess.Side.white
                        ? chess.Side.white
                        : chess.Side.black;
                    return ListTile(
                      leading: Text(itemName),
                      title: StaticChessboard(
                        pieceAssets: PieceSet.meridaAssets,
                        size: boardSize,
                        fen: position.fen,
                        orientation: itemOrientation,
                      ),
                    );
                  },
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
        ],
      ),
      body: Center(child: content),
    );
  }
}
