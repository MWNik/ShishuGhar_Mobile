

import 'package:flutter/services.dart';

class EmojiInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = removeEmojis(newValue.text);
    return TextEditingValue(
      text: newText,
      selection: newValue.selection,
    );
  }

  String removeEmojis(String text) {
    return text.replaceAll(RegExp(
        r'[\u{1F600}-\u{1F64F}|'    // Emoticons
        r'\u{1F300}-\u{1F5FF}|'    // Miscellaneous Symbols and Pictographs
        r'\u{1F680}-\u{1F6FF}|'    // Transport and Map Symbols
        r'\u{1F700}-\u{1F77F}|'    // Alchemical Symbols
        r'\u{1F780}-\u{1F7FF}|'    // Geometric Shapes Extended
        r'\u{1F800}-\u{1F8FF}|'    // Supplemental Arrows-C
        r'\u{1F900}-\u{1F9FF}|'    // Supplemental Symbols and Pictographs
        r'\u{1FA00}-\u{1FA6F}|'    // Chess Symbols
        r'\u{1FA70}-\u{1FAFF}|'    // Symbols and Pictographs Extended-A
        r'\u{2600}-\u{26FF}]',      // Miscellaneous Symbols
        unicode: true), '');
  }
}