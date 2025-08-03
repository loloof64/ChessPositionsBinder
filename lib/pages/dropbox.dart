import 'dart:async';
import 'dart:math';

import 'package:chess_position_binder/i18n/strings.g.dart';
import 'package:chess_position_binder/services/dropbox/dropbox_errors.dart';
import 'package:chess_position_binder/services/dropbox/dropbox_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multiple_result/multiple_result.dart';

class DropboxPage extends StatefulWidget {
  const DropboxPage({super.key});

  @override
  State<DropboxPage> createState() => _DropboxPageState();
}

class _DropboxPageState extends State<DropboxPage> {
  bool _isConnected = false;
  String _displayName = "";
  String? _photoUrl;
  String? _freeSpace;
  String? _usedSpace;
  late DropboxManager _dropboxManager;
  final TextEditingController _codeController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _dropboxManager = DropboxManager(isReadyCallback: _onDropboxReady);
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

  void _onDropboxReady() async {
    setState(() {
      _isConnected = true;
    });
    await _getUserProfile();
    await _getUsageData();
  }

  Future<void> _getUserProfile() async {
    final userProfileResult = await _dropboxManager.getUserProfile();
    switch (userProfileResult) {
      case Success():
        final displayName = userProfileResult.success.displayName;
        final photoUrl = userProfileResult.success.profilePhotoUrl;

        setState(() {
          _displayName = displayName;
          _photoUrl = photoUrl;
        });
        break;
      case Error():
        final error = userProfileResult.error;
        _handleError(error);
    }
  }

  Future<void> _getUsageData() async {
    final userUsageData = await _dropboxManager.getUserUsageData();
    switch (userUsageData) {
      case Success():
        final freeSpace = userUsageData.success.freeSpace;
        final usedSpace = userUsageData.success.usedSpace;

        setState(() {
          _freeSpace = freeSpace;
          _usedSpace = usedSpace;
        });
        break;
      case Error():
        final error = userUsageData.error;
        _handleError(error);
    }
  }

  void _handleError(RequestError error) {
    final message = switch (error) {
      NoClientAvailable() => t.pages.dropbox.request_errors.no_client_available,
      BadInput() => t.pages.dropbox.request_errors.bad_request_input,
      AuthError() => t.pages.dropbox.request_errors.authentification,
      NoPermissionError() => t.pages.dropbox.request_errors.no_permission,
      EndpointError() => t.pages.dropbox.request_errors.endpoint,
      RateLimitError() => t.pages.dropbox.request_errors.rate_limit,
      ServerError() => t.pages.dropbox.request_errors.misc,
      ExpiredCredentials() =>
        t.pages.dropbox.request_errors.expired_credentials,
      _ => t.pages.dropbox.request_errors.unknown,
    };
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
    if (error is ExpiredCredentials) {
      setState(() {
        _isConnected = false;
      });
      _dropboxManager.restartAuthProcess(_onFailedLaunchingDropboxAuthPage);
    }
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Dropbox"),
            Row(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_displayName),
                    if (_freeSpace != null && _usedSpace != null)
                      Text(
                        "$_usedSpace / $_freeSpace",
                        style: TextStyle(fontSize: 14),
                      ),
                  ],
                ),
                if (_photoUrl != null)
                  ClipOval(
                    child: Image.network(
                      _photoUrl!,
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: _isConnected == false
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
