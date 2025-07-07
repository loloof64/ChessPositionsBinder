import 'dart:io';

import 'package:flutter/material.dart';

Future<List<(String, String)>> readPositions(Directory directory) async {
  final filesAndFolders = await directory.list().toList();
  final pgnFiles = filesAndFolders.where((elt) {
    final isFile = elt is File;
    final isPgn = elt.path.endsWith('.pgn');
    return isFile && isPgn;
  });

  List<(String, String)> results = [];

  for (var file in pgnFiles) {
    try {
      final content = await (file as File).readAsString();
      final name = file.path.split('/').last;
      results.add((name, content));
    } catch (e) {
      debugPrint(e.toString());
      continue;
    }
  }

  return results;
}
