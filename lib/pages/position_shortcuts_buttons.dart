import 'package:flutter/material.dart';

class PositionShortcutButtons extends StatelessWidget {
  const PositionShortcutButtons({super.key});

  void _pasteFromClipboard() {}

  void _copyToClipboard() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 4,
      children: [
        ElevatedButton(
          onPressed: _pasteFromClipboard,
          child: Text("Paste FEN"),
        ),
        ElevatedButton(onPressed: _copyToClipboard, child: Text("Copy FEN")),
      ],
    );
  }
}
