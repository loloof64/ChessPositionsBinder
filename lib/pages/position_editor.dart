import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';

class PositionEditorPage extends StatefulWidget {
  final String? initialFen;
  const PositionEditorPage({super.key, this.initialFen});

  @override
  State<PositionEditorPage> createState() => _PositionEditorPageState();
}

class _PositionEditorPageState extends State<PositionEditorPage> {
  Map<Square, Piece> _pieces = {};

  /// The piece to add when a square is touched. If null, will delete the piece.
  Piece? _pieceToAddOnTouch;

  @override
  void initState() {
    super.initState();
    if (widget.initialFen != null) {
      setState(() {
        _pieces = readFen(widget.initialFen!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const pieceButtonSize = 25.0;
    const piecesButtonsRowSize = 30.0;
    const piecesButtonsRowSpacing = 10.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Position Editor"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ChessboardEditor(
            size: 200.0,
            orientation: Side.white,
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
                    color: _pieceToAddOnTouch == null ? Colors.lightBlue : null,
                    child: Icon(Icons.delete, color: Colors.red),
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
                    color: _pieceToAddOnTouch == null ? Colors.lightBlue : null,
                    child: Icon(Icons.delete, color: Colors.red),
                  ),
                  onTap: () => setState(() => _pieceToAddOnTouch = null),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
