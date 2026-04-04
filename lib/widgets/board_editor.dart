import 'package:chess_position_binder/i18n/strings.g.dart';
import 'package:chess_position_binder/widgets/position_metadata_controller.dart';
import 'package:editable_chess_board/editable_chess_board.dart';
import 'package:flutter/material.dart';

class BoardEditor extends StatefulWidget {
  final PositionMetadataControlller positionController;
  const BoardEditor({super.key, required this.positionController});

  @override
  State<BoardEditor> createState() => _BoardEditorState();
}

class _BoardEditorState extends State<BoardEditor> {
  late final PositionController _positionController;
  @override
  void initState() {
    super.initState();
    _positionController = PositionController(widget.positionController.fen);
    _positionController.addListener(() {
      widget.positionController.fen = _positionController.position;
    });
  }

  @override
  void dispose() {
    _positionController.dispose();
    super.dispose();
  }

  bool isWhiteTurn() {
    final turnPart = widget.positionController.fen.split(" ")[1];
    return turnPart == "w";
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    return EditableChessBoard(
      boardSize: isPortrait ? 300 : 200,
      labels: Labels(
        playerTurnLabel: t.pages.position_editor.editor_labels.player_turn,
        whitePlayerLabel: t.pages.position_editor.editor_labels.white_player,
        blackPlayerLabel: t.pages.position_editor.editor_labels.black_player,
        availableCastlesLabel:
            t.pages.position_editor.editor_labels.available_castles,
        whiteOOLabel: t.pages.position_editor.editor_labels.white_OO,
        whiteOOOLabel: t.pages.position_editor.editor_labels.white_OOO,
        blackOOLabel: t.pages.position_editor.editor_labels.black_OO,
        blackOOOLabel: t.pages.position_editor.editor_labels.black_OOO,
        enPassantLabel: t.pages.position_editor.editor_labels.en_passant,
        drawHalfMovesCountLabel:
            t.pages.position_editor.editor_labels.draw_moves_half_count,
        moveNumberLabel: t.pages.position_editor.editor_labels.move_number,
        submitFieldLabel: t.pages.position_editor.editor_labels.submit_field,
        currentPositionLabel:
            t.pages.position_editor.editor_labels.current_position,
        copyFenLabel: t.pages.position_editor.editor_labels.copy_fen,
        pasteFenLabel: t.pages.position_editor.editor_labels.paste_fen,
        resetPosition: t.pages.position_editor.editor_labels.reset_position,
        standardPosition:
            t.pages.position_editor.editor_labels.standard_position,
        erasePosition: t.pages.position_editor.editor_labels.erase_position,
      ),
      controller: _positionController,
      showAdvancedOptions: true,
    );
  }
}
