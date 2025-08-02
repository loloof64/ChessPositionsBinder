import 'dart:async';
import 'dart:math';

import 'package:chess_position_binder/i18n/strings.g.dart';
import 'package:chess_position_binder/services/dropbox/dropbox_manager.dart';
import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart';

class DropboxPage extends StatefulWidget {
  const DropboxPage({super.key});

  @override
  State<DropboxPage> createState() => _DropboxPageState();
}

class _DropboxPageState extends State<DropboxPage> {
  Client? _dropboxClient;
  final TextEditingController _codeController = TextEditingController(text: '');
  bool _invalidCode = false;

  @override
  void initState() {
    super.initState();
    _tryStartingDropbox();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _tryStartingDropbox() async {
    await startDropboxAuthProcess(
      _onGotDropboxClient,
      _onFailedGettingDropboxClientCallback,
    );
  }

  void _onGotDropboxClient(Client dropboxClient) {
    setState(() {
      _dropboxClient = dropboxClient;
    });
  }

  Future<void> _onFailedGettingDropboxClientCallback() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.pages.dropbox.failed_getting_auth_page)),
    );
    await Future.delayed(Duration(seconds: 1));
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  void _checkCode() {
    setState(() {
      _invalidCode = false;
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
                    onPressed: _checkCode,
                    child: Text(t.pages.overall.buttons.validate),
                  ),
                  if (_invalidCode)
                    Text(
                      t.pages.dropbox.invalid_auth_code,
                      style: TextStyle(color: Colors.red),
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
