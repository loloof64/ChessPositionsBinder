import 'package:flutter/material.dart';

class PositionShortcutButtons extends StatelessWidget {
  const PositionShortcutButtons({super.key});

  void _pasteFromClipboard() {}

  void _copyToClipboard() {}

  void _clearBoard() {}

  void _resetFen() {}

  void _setupStartPosition() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 8,
      children: [
        ElevatedButton(
          onPressed: _pasteFromClipboard,
          child: Text("Paste FEN"),
        ),
        ElevatedButton(onPressed: _copyToClipboard, child: Text("Copy FEN")),
        ElevatedButton(onPressed: _clearBoard, child: Text("Clear")),
        ElevatedButton(onPressed: _resetFen, child: Text("Reset")),
        ElevatedButton(
          onPressed: _setupStartPosition,
          child: Text("Start position"),
        ),
      ],
    );
  }
}
