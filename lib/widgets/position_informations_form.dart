import 'package:chess_position_binder/widgets/position_metadata_controller.dart';
import 'package:flutter/material.dart';

class PositionInformationsForm extends StatefulWidget {
  final PositionMetadataControlller? metadataController;
  const PositionInformationsForm({super.key, this.metadataController});

  @override
  State<PositionInformationsForm> createState() =>
      _PositionInformationsFormState();
}

class _PositionInformationsFormState extends State<PositionInformationsForm> {
  final TextEditingController _whitePlayerController = TextEditingController();
  final TextEditingController _blackPlayerController = TextEditingController();
  final TextEditingController _eventController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _exerciceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _whitePlayerController.text = widget.metadataController?.whitePlayer ?? "";
    _blackPlayerController.text = widget.metadataController?.blackPlayer ?? "";
    _eventController.text = widget.metadataController?.event ?? "";
    _dateController.text = widget.metadataController?.date ?? "";
    _exerciceController.text = widget.metadataController?.exercice ?? "";

    _whitePlayerController.addListener(() {
      widget.metadataController?.updateWhitePlayer(_whitePlayerController.text);
    });
    _blackPlayerController.addListener(() {
      widget.metadataController?.updateBlackPlayer(_blackPlayerController.text);
    });
    _eventController.addListener(() {
      widget.metadataController?.updateEvent(_eventController.text);
    });
    _dateController.addListener(() {
      widget.metadataController?.updateDate(_dateController.text);
    });
    _exerciceController.addListener(() {
      widget.metadataController?.updateExercice(_exerciceController.text);
    });
  }

  @override
  void dispose() {
    _whitePlayerController.dispose();
    _blackPlayerController.dispose();
    _eventController.dispose();
    _dateController.dispose();
    _exerciceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: TextField(
            controller: _whitePlayerController,
            decoration: const InputDecoration(labelText: "White player"),
          ),
        ),
        Flexible(
          child: TextField(
            controller: _blackPlayerController,
            decoration: const InputDecoration(labelText: "Black player"),
          ),
        ),
        Flexible(
          child: TextField(
            controller: _eventController,
            decoration: const InputDecoration(labelText: "Event"),
          ),
        ),
        Flexible(
          child: TextField(
            controller: _dateController,
            decoration: const InputDecoration(labelText: "Date"),
          ),
        ),
        Flexible(
          child: TextField(
            controller: _exerciceController,
            decoration: const InputDecoration(labelText: "Exercice"),
          ),
        ),
      ],
    );
  }
}
