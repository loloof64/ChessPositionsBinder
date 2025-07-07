import 'package:chess_position_binder/widgets/board_editor.dart';
import 'package:flutter/material.dart';

class PositionEditorPage extends StatefulWidget {
  final String initialFen;
  const PositionEditorPage({super.key, required this.initialFen});

  @override
  State<PositionEditorPage> createState() => _PositionEditorPageState();
}

class _PositionEditorPageState extends State<PositionEditorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Position Editor"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BoardEditor(initialFen: widget.initialFen),
    );
  }
}
