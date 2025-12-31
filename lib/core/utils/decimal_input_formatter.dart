import 'package:flutter/services.dart';

/// A [TextInputFormatter] that only allows decimal numbers.
///
/// Filters out any characters that are not digits or decimal separators.
/// Converts commas to dots for consistent decimal representation.
/// Ensures only one decimal separator is present.
class DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Replace commas with dots
    var text = newValue.text.replaceAll(',', '.');

    // Filter to only allow digits, dots, and minus sign at the start
    final buffer = StringBuffer();
    var hasDot = false;
    var hasMinusSign = false;

    for (var i = 0; i < text.length; i++) {
      final char = text[i];

      if (char == '-' && i == 0 && !hasMinusSign) {
        buffer.write(char);
        hasMinusSign = true;
      } else if (char == '.' && !hasDot) {
        buffer.write(char);
        hasDot = true;
      } else if (RegExp(r'[0-9]').hasMatch(char)) {
        buffer.write(char);
      }
    }

    final filteredText = buffer.toString();

    // If the text didn't change, return the new value with original selection
    if (filteredText == newValue.text) {
      return newValue;
    }

    // Calculate new cursor position
    final selectionOffset = filteredText.length -
        (newValue.text.length - newValue.selection.end).clamp(
          0,
          filteredText.length,
        );

    return TextEditingValue(
      text: filteredText,
      selection: TextSelection.collapsed(
        offset: selectionOffset.clamp(0, filteredText.length),
      ),
    );
  }
}

