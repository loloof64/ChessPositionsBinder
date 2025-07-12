import 'dart:io';

import 'package:flutter/material.dart';

/*
Returns a Future of List of Tuple
Tuple def = (name, content, isFolder)
*/
Future<List<(String, String, bool)>> readElements(Directory directory) async {
  final filesAndFolders = await directory.list().toList();
  final pgnFiles = filesAndFolders.where((elt) {
    final isFile = elt is File;
    final isPgn = elt.path.endsWith('.pgn');
    return isFile && isPgn || !isFile;
  });

  List<(String, String, bool)> results = [];

  for (var file in pgnFiles) {
    try {
      final isFolder = await FileSystemEntity.isDirectory(file.path);
      if (isFolder) {
        results.add((file.path.split('/').last, '', true));
      } else {
        final content = await (file as File).readAsString();
        final name = file.path.split('/').last;
        results.add((name, content, false));
      }
    } catch (e) {
      debugPrint(e.toString());
      continue;
    }
  }

  results.sort((a, b) {
    final aIsFolder = FileSystemEntity.isDirectorySync(a.$1);
    final bIsFolder = FileSystemEntity.isDirectorySync(b.$1);
    if (aIsFolder && !bIsFolder) {
      return -1;
    }
    if (!aIsFolder && bIsFolder) {
      return 1;
    }
    return a.$1.compareTo(b.$1);
  });

  return results;
}
