import 'package:flutter/material.dart';

class PositionMetadataControlller with ChangeNotifier {
  String _whitePlayer;
  String _blackPlayer;
  String _event;
  String _date;
  String _exercice;

  PositionMetadataControlller({
    required String whitePlayer,
    required String blackPlayer,
    required String event,
    required String date,
    required String exercice,
  }) : _whitePlayer = whitePlayer,
       _blackPlayer = blackPlayer,
       _event = event,
       _date = date,
       _exercice = exercice;

  void updateWhitePlayer(String newWhitePlayer) {
    _whitePlayer = newWhitePlayer;
    notifyListeners();
  }

  void updateBlackPlayer(String newBlackPlayer) {
    _blackPlayer = newBlackPlayer;
    notifyListeners();
  }

  void updateEvent(String newEvent) {
    _event = newEvent;
    notifyListeners();
  }

  void updateDate(String newDate) {
    _date = newDate;
    notifyListeners();
  }

  void updateExercice(String newExercice) {
    _exercice = newExercice;
    notifyListeners();
  }

  String get whitePlayer => _whitePlayer;
  String get blackPlayer => _blackPlayer;
  String get event => _event;
  String get date => _date;
  String get exercice => _exercice;
}
