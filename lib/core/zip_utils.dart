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
