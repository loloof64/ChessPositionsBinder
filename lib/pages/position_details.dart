import 'package:chess_position_binder/i18n/strings.g.dart';
import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart' as chess;
import 'package:flutter/material.dart';

class PositionDetailsPage extends StatelessWidget {
  PositionDetailsPage({
    super.key,
    required this.fileName,
    required this.fen,
    required this.whitePlayer,
    required this.blackPlayer,
    required this.event,
    required this.date,
    this.exercice = "",
  }) : _pieces = readFen(fen),
       _isBlackTurn = fen.split(" ")[1] != "w";

  final String fileName;
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
    final screenMinSize = MediaQuery.sizeOf(context).shortestSide;
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    final positionSize = isPortrait ? screenMinSize * 0.9 : screenMinSize * 0.5;
    final displayedFilename = fileName.endsWith(".pgn")
        ? fileName.substring(0, fileName.length - 4)
        : fileName;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: _isBlackTurn ? Colors.black : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey),
              ),
            ),

            Text(t.pages.position_details.title(fileName: displayedFilename)),
          ],
        ),
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
                  size: positionSize,
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
