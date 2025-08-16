import 'package:chess_position_binder/i18n/strings.g.dart';
import 'package:chess_position_binder/widgets/position_controller.dart';
import 'package:flutter/material.dart';
import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class BoardEditor extends StatefulWidget {
  final PositionController? positionController;
  const BoardEditor({super.key, required this.positionController});

  @override
  State<BoardEditor> createState() => _BoardEditorState();
}

class _BoardEditorState extends State<BoardEditor> {
  Map<Square, Piece> _pieces = {};

  /// The piece to add when a square is touched. If null, will delete the piece.
  Piece? _pieceToAddOnTouch;

  bool _isBlackTurn = false;

  @override
  void initState() {
    super.initState();
    _isBlackTurn = !isWhiteTurn();
    setState(() {
      _pieces = readFen(
        widget.positionController?.fen ??
            "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
      );
    });
  }

  bool isWhiteTurn() {
    final turnPart = widget.positionController?.fen.split(" ")[1];
    return turnPart == "w";
  }

  @override
  Widget build(BuildContext context) {
    final screenMinSize = MediaQuery.sizeOf(context).shortestSide;
    final pieceButtonSize = screenMinSize * 0.065;
    final piecesButtonsRowSize = screenMinSize * 0.07;
    final piecesButtonsRowSpacing = 4.0;

    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;

    final editorButtons = Column(
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: piecesButtonsRowSize,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: piecesButtonsRowSpacing,
            children: [
              InkWell(
                child: Container(
                  color: _pieceToAddOnTouch == Piece.whitePawn
                      ? Colors.lightBlue
                      : null,
                  child: WhitePawn(size: pieceButtonSize),
                ),
                onTap: () => setState(() {
                  _pieceToAddOnTouch = Piece.whitePawn;
                }),
              ),
              InkWell(
                child: Container(
                  color: _pieceToAddOnTouch == Piece.whiteKnight
                      ? Colors.lightBlue
                      : null,
                  child: WhiteKnight(size: pieceButtonSize),
                ),
                onTap: () => setState(() {
                  _pieceToAddOnTouch = Piece.whiteKnight;
                }),
              ),
              InkWell(
                child: Container(
                  color: _pieceToAddOnTouch == Piece.whiteBishop
                      ? Colors.lightBlue
                      : null,
                  child: WhiteBishop(size: pieceButtonSize),
                ),
                onTap: () =>
                    setState(() => _pieceToAddOnTouch = Piece.whiteBishop),
              ),
              InkWell(
                child: Container(
                  color: _pieceToAddOnTouch == Piece.whiteRook
                      ? Colors.lightBlue
                      : null,
                  child: WhiteRook(size: pieceButtonSize),
                ),
                onTap: () {
                  setState(() => _pieceToAddOnTouch = Piece.whiteRook);
                },
              ),
              InkWell(
                child: Container(
                  color: _pieceToAddOnTouch == Piece.whiteQueen
                      ? Colors.lightBlue
                      : null,
                  child: WhiteQueen(size: pieceButtonSize),
                ),
                onTap: () =>
                    setState(() => _pieceToAddOnTouch = Piece.whiteQueen),
              ),
              InkWell(
                child: Container(
                  color: _pieceToAddOnTouch == Piece.whiteKing
                      ? Colors.lightBlue
                      : null,
                  child: WhiteKing(size: pieceButtonSize),
                ),
                onTap: () =>
                    setState(() => _pieceToAddOnTouch = Piece.whiteKing),
              ),
              InkWell(
                child: Container(
                  width: pieceButtonSize,
                  height: pieceButtonSize,
                  color: _pieceToAddOnTouch == null ? Colors.lightBlue : null,
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: pieceButtonSize,
                  ),
                ),
                onTap: () => setState(() => _pieceToAddOnTouch = null),
              ),
            ],
          ),
        ),
        SizedBox(
          height: piecesButtonsRowSize,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: piecesButtonsRowSpacing,
            children: [
              InkWell(
                child: Container(
                  color: _pieceToAddOnTouch == Piece.blackPawn
                      ? Colors.lightBlue
                      : null,
                  child: BlackPawn(size: pieceButtonSize),
                ),
                onTap: () =>
                    setState(() => _pieceToAddOnTouch = Piece.blackPawn),
              ),
              InkWell(
                child: Container(
                  color: _pieceToAddOnTouch == Piece.blackKnight
                      ? Colors.lightBlue
                      : null,
                  child: BlackKnight(size: pieceButtonSize),
                ),
                onTap: () =>
                    setState(() => _pieceToAddOnTouch = Piece.blackKnight),
              ),
              InkWell(
                child: Container(
                  color: _pieceToAddOnTouch == Piece.blackBishop
                      ? Colors.lightBlue
                      : null,
                  child: BlackBishop(size: pieceButtonSize),
                ),
                onTap: () =>
                    setState(() => _pieceToAddOnTouch = Piece.blackBishop),
              ),
              InkWell(
                child: Container(
                  color: _pieceToAddOnTouch == Piece.blackRook
                      ? Colors.lightBlue
                      : null,
                  child: BlackRook(size: pieceButtonSize),
                ),
                onTap: () =>
                    setState(() => _pieceToAddOnTouch = Piece.blackRook),
              ),
              InkWell(
                child: Container(
                  color: _pieceToAddOnTouch == Piece.blackQueen
                      ? Colors.lightBlue
                      : null,
                  child: BlackQueen(size: pieceButtonSize),
                ),
                onTap: () =>
                    setState(() => _pieceToAddOnTouch = Piece.blackQueen),
              ),
              InkWell(
                child: Container(
                  color: _pieceToAddOnTouch == Piece.blackKing
                      ? Colors.lightBlue
                      : null,
                  child: BlackKing(size: pieceButtonSize),
                ),
                onTap: () =>
                    setState(() => _pieceToAddOnTouch = Piece.blackKing),
              ),
              InkWell(
                child: Container(
                  width: pieceButtonSize,
                  height: pieceButtonSize,
                  color: _pieceToAddOnTouch == null ? Colors.lightBlue : null,
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: pieceButtonSize,
                  ),
                ),
                onTap: () => setState(() => _pieceToAddOnTouch = null),
              ),
            ],
          ),
        ),
      ],
    );

    final mainContentChildren = [
      ChessboardEditor(
        size: screenMinSize * 0.60,
        settings: ChessboardSettings(enableCoordinates: true),
        orientation: _isBlackTurn ? Side.black : Side.white,
        pieces: _pieces,
        pointerMode: EditorPointerMode.edit,
        onEditedSquare: (squareId) => setState(() {
          if (_pieceToAddOnTouch != null) {
            _pieces[squareId] = _pieceToAddOnTouch!;
          } else {
            _pieces.remove(squareId);
          }
          widget.positionController?.updateBoardPart(writeFen(_pieces));
        }),
        onDiscardedPiece: (squareId) => setState(() {
          _pieces.remove(squareId);
          widget.positionController?.updateBoardPart(writeFen(_pieces));
        }),
        onDroppedPiece: (origin, destination, piece) => setState(() {
          _pieces[destination] = piece;
          if (origin != null && origin != destination) {
            _pieces.remove(origin);
            widget.positionController?.updateBoardPart(writeFen(_pieces));
          }
        }),
      ),
      editorButtons,
    ];

    return Column(
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: piecesButtonsRowSize,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(t.widgets.board_editor.black_turn),
              IconButton(
                icon: Icon(
                  _isBlackTurn ? Icons.toggle_on : Icons.toggle_off,
                  color: _isBlackTurn ? Colors.blue : Colors.black12,
                ),
                onPressed: () => setState(() {
                  _isBlackTurn = !_isBlackTurn;
                  widget.positionController?.toggleTurn();
                }),
              ),
            ],
          ),
        ),
        isPortrait
            ? Column(children: mainContentChildren)
            : Center(
                child: Row(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  children: mainContentChildren,
                ),
              ),
      ],
    );
  }
}
