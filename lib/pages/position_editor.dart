import 'package:chess_position_binder/pages/position_shortcuts_buttons.dart';
import 'package:chess_position_binder/widgets/board_editor.dart';
import 'package:chess_position_binder/widgets/position_controller.dart';
import 'package:chess_position_binder/widgets/position_informations_form.dart';
import 'package:chess_position_binder/widgets/position_metadata_controller.dart';
import 'package:dartchess/dartchess.dart' as chess;
import 'package:flutter/material.dart';

class PositionEditorPage extends StatefulWidget {
  final String initialFen;
  final String whitePlayer;
  final String blackPlayer;
  final String event;
  final String date;
  final String exercice;
  final bool editingExistingFile;

  const PositionEditorPage({
    super.key,
    this.initialFen =
        "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
    this.whitePlayer = "",
    this.blackPlayer = "",
    this.event = "",
    this.date = "",
    this.exercice = "",
    required this.editingExistingFile,
  });

  @override
  State<PositionEditorPage> createState() => _PositionEditorPageState();
}

class _PositionEditorPageState extends State<PositionEditorPage> {
  PositionController? _positionController;
  PositionMetadataControlller? _positionMetadataController;

  @override
  void initState() {
    super.initState();
    _positionController = PositionController(initialFen: widget.initialFen);
    _positionMetadataController = PositionMetadataControlller(
      whitePlayer: widget.whitePlayer,
      blackPlayer: widget.blackPlayer,
      event: widget.event,
      date: widget.date,
      exercice: widget.exercice,
    );
  }

  @override
  void dispose() {
    _positionMetadataController?.dispose();
    _positionController?.dispose();
    super.dispose();
  }

  Future<String?> _getSavedFileName() {
    String? inputValue;
    return showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select saved file name"),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(labelText: "File name"),
            onChanged: (value) {
              inputValue = value;
            },
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Save"),
              onPressed: () {
                Navigator.of(context).pop(inputValue);
              },
            ),
          ],
        );
      },
    );
  }

  void _showPasteError(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _returnPgn() async {
    Map<String, String> headers = {};
    if (_positionMetadataController != null &&
        _positionMetadataController!.whitePlayer.isNotEmpty) {
      headers["White"] = _positionMetadataController!.whitePlayer;
    }
    if (_positionMetadataController != null &&
        _positionMetadataController!.blackPlayer.isNotEmpty) {
      headers["Black"] = _positionMetadataController!.blackPlayer;
    }
    if (_positionMetadataController != null &&
        _positionMetadataController!.event.isNotEmpty) {
      headers["Event"] = _positionMetadataController!.event;
    }
    if (_positionMetadataController != null &&
        _positionMetadataController!.date.isNotEmpty) {
      headers["Date"] = _positionMetadataController!.date;
    }
    if (_positionMetadataController != null &&
        _positionMetadataController!.exercice.isNotEmpty) {
      headers["Exercice"] = _positionMetadataController!.exercice;
    }

    if (_positionController != null) {
      headers["FEN"] = _positionController!.fen;
    }
    final pgnHolder = chess.PgnGame(
      headers: headers,
      moves: chess.PgnNode(),
      comments: [],
    );
    final pgn = pgnHolder.makePgn();
    if (widget.editingExistingFile) {
      Navigator.of(context).pop((pgn, ""));
    } else {
      final savedName = await _getSavedFileName();
      if (savedName == null) return;
      String fileName = savedName;
      if (!fileName.endsWith('pgn')) {
        fileName += '.pgn';
      }
      if (context.mounted) {
        Navigator.of(context).pop((pgn, fileName));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Position Editor"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.edit)),
              Tab(icon: Icon(Icons.info)),
              Tab(icon: Icon(Icons.double_arrow)),
            ],
          ),
          actions: [
            IconButton(icon: const Icon(Icons.save), onPressed: _returnPgn),
          ],
        ),
        body: TabBarView(
          children: [
            Center(child: BoardEditor(positionController: _positionController)),
            Center(
              child: PositionInformationsForm(
                metadataController: _positionMetadataController,
              ),
            ),
            Center(
              child: PositionShortcutButtons(
                startFen: widget.initialFen,
                positionController: _positionController,
                onPasteError: (message) => _showPasteError(message),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
