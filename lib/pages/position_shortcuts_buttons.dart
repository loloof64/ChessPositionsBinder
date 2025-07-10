import 'package:chess_position_binder/widgets/position_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dartchess/dartchess.dart' as chess;

class PositionShortcutButtons extends StatelessWidget {
  final String startFen;
  final PositionController? positionController;
  final void Function(String message)? onPasteError;

  const PositionShortcutButtons({
    super.key,
    this.onPasteError,
    required this.startFen,
    required this.positionController,
  });

  void _pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    String? fen = clipboardData?.text;
    if (fen == null) {
      return;
    }
    try {
      final newChessLogic = chess.Chess.fromSetup(chess.Setup.parseFen(fen));
      positionController?.replaceFen(newChessLogic.fen);
    } catch (e) {
      debugPrint(e.toString());
      if (onPasteError != null) {
        onPasteError!("Failed to paste FEN !");
      }
      return;
    }
  }

  void _copyToClipboard() async {
    if (positionController == null) return;
    await Clipboard.setData(ClipboardData(text: positionController!.value));
  }

  void _clearBoard() {
    positionController?.replaceFen("8/8/8/8/8/8/8/8 w - - 0 1");
  }

  void _resetFen() {
    positionController?.replaceFen(startFen);
  }

  void _setupStartPosition() {
    positionController?.replaceFen(
      "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
    );
  }

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
