import 'dart:io';

import 'package:chess_position_binder/core/text_utils.dart';
import 'package:path/path.dart' as p;

bool isAllowedFileForArchive(File file) {
  final fileExtension = p.extension(file.path).toLowerCase();
  if (fileExtension == '.zip') {
    return true;
  }
  final fileContent = file.readAsStringSync();
  return isTextContent(fileContent);
}

Future<String> getNextPathCopyFor(String filePath) async {
  final pathSeparator = Platform.pathSeparator;
  final parts = filePath.split(pathSeparator);
  final startName = parts.last;
  parts.removeLast();
  final basePath = parts.join(pathSeparator);

  String nextName = _getNextFileCopyName(startName);
  String nextPath = "$basePath${Platform.pathSeparator}$nextName";
  while (await File(nextPath).exists()) {
    nextName = _getNextFileCopyName(nextName);
    nextPath = "$basePath${Platform.pathSeparator}$nextName";
  }
  return nextPath;
}

String _getNextFileCopyName(String simpleName) {
  // Regex to find patterns like (number)
  final fileNameRegex = RegExp(r"\((?<id>\d+)\)");

  // Find all matches and get the last one
  final lastMatch = fileNameRegex.allMatches(simpleName).lastOrNull;

  if (lastMatch == null) {
    // No (number) pattern found in the name
    final parts = simpleName.split(".");
    if (parts.length <= 1) {
      // No extension or single part name
      return "$simpleName(1)";
    }
    // Has an extension
    final fileExt = parts.last;
    parts.removeLast(); // Remove the extension
    final baseName = parts.join("."); // Reconstruct base name
    return "$baseName(1).$fileExt";
  } else {
    // An (number) pattern was found, increment it
    final currentId = int.parse(lastMatch.namedGroup("id").toString());
    final nextId = currentId + 1;

    // Replace the last matched (number) with (nextId)
    // Get the part before the match
    final prefix = simpleName.substring(0, lastMatch.start);
    // Get the part after the match
    final suffix = simpleName.substring(lastMatch.end);

    return "$prefix($nextId)$suffix";
  }
}
