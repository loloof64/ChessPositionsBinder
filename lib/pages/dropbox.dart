import 'dart:async';
import 'dart:math';

import 'package:chess_position_binder/i18n/strings.g.dart';
import 'package:chess_position_binder/services/dropbox/dropbox_manager.dart';
import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart';
import 'package:flutter/services.dart';

class DropboxPage extends StatefulWidget {
  const DropboxPage({super.key});

  @override
  State<DropboxPage> createState() => _DropboxPageState();
}

class _DropboxPageState extends State<DropboxPage> {
  Client? _dropboxClient;
  late DropboxManager _dropboxManager;
  final TextEditingController _codeController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _dropboxManager = DropboxManager(gotClientCallback: _onGotDropboxClient);
    _tryStartingDropbox();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _tryStartingDropbox() async {
    await _dropboxManager.startDropboxAuthProcess(
      _onFailedLaunchingDropboxAuthPage,
    );
  }

  void _onGotDropboxClient(Client dropboxClient) {
    setState(() {
      _dropboxClient = dropboxClient;
    });
  }

  Future<void> _onFailedLaunchingDropboxAuthPage() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.pages.dropbox.failed_getting_auth_page)),
    );
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _checkCode() async {
    final token = _codeController.text;
    final authSuccess = await _dropboxManager.authenticateWithToken(token);
    if (authSuccess != TokenAuthResult.success) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.pages.dropbox.invalid_auth_code)),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData('text/plain');
    final clipboardText = clipboardData?.text ?? '';
    setState(() {
      _codeController.text = clipboardText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final orientation = mediaQuery.orientation;
    final isPortrait = orientation == Orientation.portrait;

    final smallestDimension = min(screenWidth, screenHeight);

    // Based on standard breakpoints
    bool isMobile = smallestDimension < 600;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Dropbox"),
      ),
      body: Center(
        child: _dropboxClient == null
            ? Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(t.pages.dropbox.enter_auth_code),
                  TextField(controller: _codeController),
                  ElevatedButton(
                    onPressed: _pasteFromClipboard,
                    child: Text(t.pages.overall.buttons.paste),
                  ),
                  ElevatedButton(
                    onPressed: _checkCode,
                    child: Text(t.pages.overall.buttons.validate),
                  ),
                ],
              )
            : Column(
                children: [
                  if (isMobile)
                    const Text("Mobile")
                  else
                    Text("Tablet/Desktop"),
                  Text("Résolution : $screenWidth x $screenHeight"),
                  Text("Orientation : ${isPortrait ? 'Portrait' : 'Paysage'}"),
                ],
              ),
      ),
    );
  }
}
