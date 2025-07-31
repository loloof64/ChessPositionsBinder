import 'package:chess_position_binder/i18n/strings.g.dart';
import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart' as chess;
import 'package:flutter/material.dart';

class PositionDetailsPage extends StatelessWidget {
  PositionDetailsPage({
    super.key,
    required this.fen,
    required this.whitePlayer,
    required this.blackPlayer,
    required this.event,
    required this.date,
    this.exercice = "",
  }) : _pieces = readFen(fen),
       _isBlackTurn = fen.split(" ")[1] != "w";

  final String fen;
  final String whitePlayer;
  final String blackPlayer;
  final String event;
  final String date;
  final String exercice;

  final bool _isBlackTurn;
  final Map<chess.Square, chess.Piece> _pieces;

  @override
  Widget build(BuildContext context) {
    final screenMinSize = MediaQuery.of(context).size.shortestSide;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.pages.position_details.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8,
              children: [
                ChessboardEditor(
                  size: screenMinSize * 0.5,
                  settings: ChessboardSettings(enableCoordinates: true),
                  orientation: _isBlackTurn
                      ? chess.Side.black
                      : chess.Side.white,
                  pieces: _pieces,
                ),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 8,
                    children: [Text(whitePlayer), Text("-"), Text(blackPlayer)],
                  ),
                ),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 8,
                    children: [Text(event), Text("|"), Text(date)],
                  ),
                ),
                Text(
                  exercice,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
