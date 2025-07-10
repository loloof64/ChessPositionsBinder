import 'package:flutter/widgets.dart';

class PositionController extends ValueNotifier<String> {
  PositionController({required String initialFen}) : super(initialFen);

  String get fen => value;

  void updateBoardPart(String refFen) {
    final refBoardFen = refFen.split(" ")[0];
    final turnPart = fen.split(" ")[1];
    value = "$refBoardFen $turnPart - - 0 1";
    notifyListeners();
  }

  void replaceFen(String newFen) {
    value = newFen;
    notifyListeners();
  }

  void toggleTurn() {
    final boardPart = value.split(" ")[0];
    final turnPart = value.split(" ")[1];
    value = "$boardPart ${turnPart == "w" ? "b" : "w"} - - 0 1";
    notifyListeners();
  }
}
