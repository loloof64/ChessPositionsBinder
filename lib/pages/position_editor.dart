import 'package:chess_position_binder/i18n/strings.g.dart';
import 'package:chess_position_binder/widgets/board_editor.dart';
import 'package:chess_position_binder/widgets/position_informations_form.dart';
import 'package:chess_position_binder/widgets/position_metadata_controller.dart';
import 'package:dartchess/dartchess.dart' as chess;
import 'package:flutter/material.dart';

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
  });

  @override
  State<PositionEditorPage> createState() => _PositionEditorPageState();
}

class _PositionEditorPageState extends State<PositionEditorPage> {
  late PositionMetadataControlller _positionMetadataController;
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
  }

  @override
  void dispose() {
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
    final title =
        widget.fileName.isEmpty
            ? t.pages.position_editor.simple_title
            : t.pages.position_editor.title(fileName: widget.fileName);
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                  child: BoardEditor(
                    positionController: _positionMetadataController,
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
