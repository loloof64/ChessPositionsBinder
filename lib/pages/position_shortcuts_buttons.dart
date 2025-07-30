import 'package:chess_position_binder/i18n/strings.g.dart';
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
        onPasteError!(t.pages.position_shortcuts.errors.failed_pasting_fen);
      }
      return;
    }
  }

  void _copyToClipboard() async {
    if (positionController == null) return;
    await Clipboard.setData(ClipboardData(text: positionController!.value));
  }

  void _clearBoard() {
    positionController?.replaceFen("4k3/8/8/8/8/8/8/4K3 w - - 0 1");
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
          child: Text(t.pages.position_shortcuts.buttons.paste_fen),
        ),
        ElevatedButton(
          onPressed: _copyToClipboard,
          child: Text(t.pages.position_shortcuts.buttons.copy_fen),
        ),
        ElevatedButton(
          onPressed: _clearBoard,
          child: Text(t.pages.position_shortcuts.buttons.clear),
        ),
        ElevatedButton(
          onPressed: _resetFen,
          child: Text(t.pages.position_shortcuts.buttons.reset),
        ),
        ElevatedButton(
          onPressed: _setupStartPosition,
          child: Text(t.pages.position_shortcuts.buttons.set_start_position),
        ),
      ],
    );
  }
}
