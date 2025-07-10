import 'package:chess_position_binder/pages/position_shortcuts_buttons.dart';
import 'package:chess_position_binder/widgets/board_editor.dart';
import 'package:chess_position_binder/widgets/position_controller.dart';
import 'package:chess_position_binder/widgets/position_informations_form.dart';
import 'package:flutter/material.dart';

class PositionEditorPage extends StatefulWidget {
  final String initialFen;
  const PositionEditorPage({
    super.key,
    this.initialFen =
        "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
  });

  @override
  State<PositionEditorPage> createState() => _PositionEditorPageState();
}

class _PositionEditorPageState extends State<PositionEditorPage> {
  PositionController? _positionController;

  @override
  void initState() {
    super.initState();
    _positionController = PositionController(initialFen: widget.initialFen);
  }

  @override
  void dispose() {
    _positionController?.dispose();
    super.dispose();
  }

  void _showPasteError(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _returnPgn() {
    final pgn = "";
    Navigator.of(context).pop(pgn);
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
            Center(child: PositionInformationsForm()),
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
