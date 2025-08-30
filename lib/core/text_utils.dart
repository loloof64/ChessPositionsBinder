bool isTextContent(String content) {
  for (final rune in content.runes) {
    if (
    // Keep  Tab, LF, CR
    (rune < 32 && rune != 9 && rune != 10 && rune != 13) ||
        rune == 127 || // DEL
        (rune >= 128 && rune <= 159) || // extended control caracters
        rune >
            255 // above Latin-1
            ) {
      return false;
    }
  }
  return true;
}
