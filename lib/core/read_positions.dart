import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class RawFolderElement extends Equatable {
  final String name;
  final String content;
  final bool isFolder;

  const RawFolderElement({
    required this.name,
    required this.content,
    required this.isFolder,
  });

  @override
  String toString() {
    return "RawFolderElement($name, $isFolder)";
  }

  @override
  List<Object?> get props => [name, isFolder];
}

Future<List<RawFolderElement>> readElements(Directory directory) async {
  final filesAndFolders = await directory.list().toList();
  final pgnFiles = filesAndFolders.where((elt) {
    final isFile = elt is File;
    final isPgn = elt.path.endsWith('.pgn');
    return isFile && isPgn || !isFile;
  });

  List<RawFolderElement> results = [];

  for (var file in pgnFiles) {
    try {
      final isFolder = await FileSystemEntity.isDirectory(file.path);
      if (isFolder) {
        results.add(
          RawFolderElement(name: file.path, content: '', isFolder: true),
        );
      } else {
        final content = await (file as File).readAsString();
        results.add(
          RawFolderElement(name: file.path, content: content, isFolder: false),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      continue;
    }
  }

  results.sort((a, b) {
    final aIsFolder = FileSystemEntity.isDirectorySync(a.name);
    final bIsFolder = FileSystemEntity.isDirectorySync(b.name);
    if (aIsFolder && !bIsFolder) {
      return -1;
    }
    if (!aIsFolder && bIsFolder) {
      return 1;
    }
    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  });

  return results;
}
