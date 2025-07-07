import 'package:flutter/material.dart';

class PositionInformationsForm extends StatefulWidget {
  const PositionInformationsForm({super.key});

  @override
  State<PositionInformationsForm> createState() =>
      _PositionInformationsFormState();
}

class _PositionInformationsFormState extends State<PositionInformationsForm> {
  TextEditingController _whitePlayerController = TextEditingController();
  TextEditingController _blackPlayerController = TextEditingController();
  TextEditingController _eventController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _exerciceController = TextEditingController();

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
      ],
    );
  }
}
