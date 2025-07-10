import 'package:flutter/material.dart';
import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class BoardEditor extends StatefulWidget {
  final String initialFen;
  const BoardEditor({super.key, required this.initialFen});

  @override
  State<BoardEditor> createState() => _BoardEditorState();
}

class _BoardEditorState extends State<BoardEditor> {
  Map<Square, Piece> _pieces = {};

  /// The piece to add when a square is touched. If null, will delete the piece.
  Piece? _pieceToAddOnTouch;

  bool _blackAtBottom = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _pieces = readFen(widget.initialFen);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenMinSize = MediaQuery.of(context).size.shortestSide;
    final pieceButtonSize = screenMinSize * 0.08;
    final piecesButtonsRowSize = screenMinSize * 0.085;
    final piecesButtonsRowSpacing = 5.0;

    return Column(
      spacing: 4,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ChessboardEditor(
          size: screenMinSize * 0.60,
          settings: ChessboardSettings(enableCoordinates: true),
          orientation: _blackAtBottom ? Side.black : Side.white,
          pieces: _pieces,
          pointerMode: EditorPointerMode.edit,
          onEditedSquare: (squareId) => setState(() {
            if (_pieceToAddOnTouch != null) {
              _pieces[squareId] = _pieceToAddOnTouch!;
            } else {
              _pieces.remove(squareId);
            }
          }),
          onDiscardedPiece: (squareId) => setState(() {
            _pieces.remove(squareId);
          }),
          onDroppedPiece: (origin, destination, piece) => setState(() {
            _pieces[destination] = piece;
            if (origin != null && origin != destination) {
              _pieces.remove(origin);
            }
          }),
        ),
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
                child: IconButton(
                  icon: Icon(
                    _blackAtBottom ? Icons.toggle_on : Icons.toggle_off,
                    size: pieceButtonSize * 0.7,
                  ),
                  onPressed: () =>
                      setState(() => _blackAtBottom = !_blackAtBottom),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
