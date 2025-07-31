import 'dart:math';

import 'package:flutter/material.dart';

class DropboxPage extends StatefulWidget {
  const DropboxPage({super.key});

  @override
  State<DropboxPage> createState() => _DropboxPageState();
}

class _DropboxPageState extends State<DropboxPage> {
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
      appBar: AppBar(title: const Text("Dropbox")),
      body: Center(
        child: Column(
          children: [
            if (isMobile) const Text("Mobile") else Text("Tablet/Desktop"),
            Text("Résolution : $screenWidth x $screenHeight"),
            Text("Orientation : ${isPortrait ? 'Portrait' : 'Paysage'}"),
          ],
        ),
      ),
    );
  }
}
