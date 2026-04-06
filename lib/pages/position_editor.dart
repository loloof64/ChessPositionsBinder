import 'dart:io';

import 'package:chess_position_binder/core/chess_recognizer.dart';
import 'package:chess_position_binder/i18n/strings.g.dart';
import 'package:chess_position_binder/pages/photo_ocr_process.dart';
import 'package:chess_position_binder/widgets/position_informations_form.dart';
import 'package:chess_position_binder/widgets/position_metadata_controller.dart';
import 'package:dartchess/dartchess.dart' as chess;
import 'package:editable_chess_board/editable_chess_board.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PositionEditorPage extends StatefulWidget {
  final String fileName;
  final String initialFen;
  final String whitePlayer;
  final String blackPlayer;
  final String event;
  final String date;
  final String exercice;
  final bool editingExistingFile;
  final List<String> alreadyExistingNames;
  final ChessRecognizer chessRecognizer;

  const PositionEditorPage({
    super.key,
    this.whitePlayer = "",
    this.blackPlayer = "",
    this.event = "",
    this.date = "",
    this.exercice = "",
    required this.initialFen,
    required this.alreadyExistingNames,
    required this.fileName,
    required this.editingExistingFile,
    required this.chessRecognizer,
  });

  @override
  State<PositionEditorPage> createState() => _PositionEditorPageState();
}

class _PositionEditorPageState extends State<PositionEditorPage> {
  late PositionMetadataControlller _positionMetadataController;
  late PositionController _positionController;
  String? _savedFileName;

  @override
  void initState() {
    super.initState();
    _positionMetadataController = PositionMetadataControlller(
      whitePlayer: widget.whitePlayer,
      blackPlayer: widget.blackPlayer,
      event: widget.event,
      date: widget.date,
      exercice: widget.exercice,
      fen: widget.initialFen,
    );
    _positionController = PositionController(widget.initialFen);
    _positionController.addListener(() {
      setState(() {
        _positionMetadataController.fen = _positionController.position;
      });
    });
  }

  @override
  void dispose() {
    _positionController.dispose();
    _positionMetadataController.dispose();
    super.dispose();
  }

  Future<String?> _getSavedFileName() {
    String? inputValue;
    return showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(t.pages.position_editor.saved_file_name_dialog.title),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              labelText:
                  t
                      .pages
                      .position_editor
                      .saved_file_name_dialog
                      .name_placeholder,
            ),
            onChanged: (value) {
              inputValue = value;
            },
          ),
          actions: [
            TextButton(
              child: Text(
                t.misc.buttons.cancel,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                t.misc.buttons.save,
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop(inputValue?.trim());
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _purposeScanningPhoto() async {
    final newPositionFen = await Navigator.of(context).push<String?>(
      MaterialPageRoute(
        builder: (routeCtx) {
          return PhotoOcrProcessPage(chessRecognizer: widget.chessRecognizer);
        },
      ),
    );

    if (newPositionFen == null) return;
    setState(() {
      _positionController.position = newPositionFen;
    });
  }

  Future<void> _purposeReturnPgn() async {
    AlertDialog overwriteFileConfirmationDialog() {
      return AlertDialog(
        title: Text(
          t.pages.position_editor.overwrite_file_confirmation_dialog.title,
        ),
        content: Text(
          t.pages.position_editor.overwrite_file_confirmation_dialog.message(
            fileName: _savedFileName ?? widget.fileName,
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              t.misc.buttons.cancel,
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              t.misc.buttons.ok,
              style: TextStyle(color: Colors.green),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              _returnPgn();
            },
          ),
        ],
      );
    }

    if (widget.editingExistingFile) {
      showDialog(
        context: context,
        builder: (context) {
          return overwriteFileConfirmationDialog();
        },
      );
    } else {
      final savedName = await _getSavedFileName();
      if (savedName == null) return;
      String fileName = savedName;
      if (!fileName.endsWith('pgn')) {
        fileName += '.pgn';
      }
      setState(() {
        _savedFileName = fileName;
      });
      final isOverwritingExistingFile = widget.alreadyExistingNames.contains(
        _savedFileName,
      );
      if (isOverwritingExistingFile) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) {
            return overwriteFileConfirmationDialog();
          },
        );
      } else {
        _returnPgn();
      }
    }
  }

  void _returnPgn() async {
    Map<String, String> headers = {};
    if (_positionMetadataController.whitePlayer.isNotEmpty) {
      headers["White"] = _positionMetadataController.whitePlayer;
    }
    if (_positionMetadataController.blackPlayer.isNotEmpty) {
      headers["Black"] = _positionMetadataController.blackPlayer;
    }
    if (_positionMetadataController.event.isNotEmpty) {
      headers["Event"] = _positionMetadataController.event;
    }
    if (_positionMetadataController.date.isNotEmpty) {
      headers["Date"] = _positionMetadataController.date;
    }
    if (_positionMetadataController.exercice.isNotEmpty) {
      headers["Exercice"] = _positionMetadataController.exercice;
    }

    if (_positionMetadataController.fen.isNotEmpty) {
      headers["FEN"] = _positionMetadataController.fen;
    }

    final pgnHolder = chess.PgnGame(
      headers: headers,
      moves: chess.PgnNode(),
      comments: [],
    );
    final pgn = pgnHolder.makePgn();
    if (widget.editingExistingFile) {
      Navigator.of(context).pop((pgn, ""));
    } else {
      if (context.mounted) {
        Navigator.of(context).pop((pgn, _savedFileName));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileName = widget.fileName;
    final displayedFilename =
        fileName.isEmpty
            ? fileName
            : fileName.endsWith(".pgn")
            ? fileName.substring(0, fileName.length - 4)
            : fileName;
    final title =
        displayedFilename.isEmpty
            ? t.pages.position_editor.simple_title
            : t.pages.position_editor.title(fileName: displayedFilename);
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton:
            (Platform.isAndroid || Platform.isIOS)
                ? FloatingActionButton(
                  onPressed: _purposeScanningPhoto,
                  child: FaIcon(FontAwesomeIcons.barcode),
                )
                : null,
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: const TabBar(
            tabs: [Tab(icon: Icon(Icons.edit)), Tab(icon: Icon(Icons.info))],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _purposeReturnPgn,
            ),
          ],
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: isPortrait ? 400 : 600,
                  height: isPortrait ? 600 : 250,
                  child: EditableChessBoard(
                    boardSize: isPortrait ? 300 : 200,
                    labels: Labels(
                      playerTurnLabel:
                          t.pages.position_editor.editor_labels.player_turn,
                      whitePlayerLabel:
                          t.pages.position_editor.editor_labels.white_player,
                      blackPlayerLabel:
                          t.pages.position_editor.editor_labels.black_player,
                      availableCastlesLabel:
                          t
                              .pages
                              .position_editor
                              .editor_labels
                              .available_castles,
                      whiteOOLabel:
                          t.pages.position_editor.editor_labels.white_OO,
                      whiteOOOLabel:
                          t.pages.position_editor.editor_labels.white_OOO,
                      blackOOLabel:
                          t.pages.position_editor.editor_labels.black_OO,
                      blackOOOLabel:
                          t.pages.position_editor.editor_labels.black_OOO,
                      enPassantLabel:
                          t.pages.position_editor.editor_labels.en_passant,
                      drawHalfMovesCountLabel:
                          t
                              .pages
                              .position_editor
                              .editor_labels
                              .draw_moves_half_count,
                      moveNumberLabel:
                          t.pages.position_editor.editor_labels.move_number,
                      submitFieldLabel:
                          t.pages.position_editor.editor_labels.submit_field,
                      currentPositionLabel:
                          t
                              .pages
                              .position_editor
                              .editor_labels
                              .current_position,
                      copyFenLabel:
                          t.pages.position_editor.editor_labels.copy_fen,
                      pasteFenLabel:
                          t.pages.position_editor.editor_labels.paste_fen,
                      resetPosition:
                          t.pages.position_editor.editor_labels.reset_position,
                      standardPosition:
                          t
                              .pages
                              .position_editor
                              .editor_labels
                              .standard_position,
                      erasePosition:
                          t.pages.position_editor.editor_labels.erase_position,
                    ),
                    controller: _positionController,
                    showAdvancedOptions: true,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Center(
                child: PositionInformationsForm(
                  metadataController: _positionMetadataController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
