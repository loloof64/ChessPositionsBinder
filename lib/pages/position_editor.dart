import 'package:chess_position_binder/pages/position_shortcuts_buttons.dart';
import 'package:chess_position_binder/widgets/board_editor.dart';
import 'package:chess_position_binder/widgets/position_informations_form.dart';
import 'package:flutter/material.dart';

class PositionEditorPage extends StatefulWidget {
  final String initialFen;
  const PositionEditorPage({super.key, required this.initialFen});

  @override
  State<PositionEditorPage> createState() => _PositionEditorPageState();
}

class _PositionEditorPageState extends State<PositionEditorPage> {
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
            Center(child: BoardEditor(initialFen: widget.initialFen)),
            Center(child: PositionInformationsForm()),
            Center(child: PositionShortcutButtons()),
          ],
        ),
      ),
    );
  }
}
