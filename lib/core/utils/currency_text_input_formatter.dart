import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DecimalCurrencyFormatter extends TextInputFormatter {
  final int decimalDigits;
  final bool enableNegative;
  final String thousandSeparator;
  final String decimalSeparator;

  DecimalCurrencyFormatter({
    this.decimalDigits = 2,
    this.enableNegative = false,
    this.thousandSeparator = ',',
    this.decimalSeparator = '.',
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow empty input
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Handle negative sign
    bool isNegative = false;
    String workingText = newValue.text;

    if (enableNegative && workingText.startsWith('-')) {
      isNegative = true;
      workingText = workingText.substring(1);
    }

    // Remove all non-digit and non-decimal characters
    workingText = workingText.replaceAll(RegExp('[^0-9.]'), '');

    // Handle multiple decimal points - keep only the first one
    List<String> parts = workingText.split('.');
    if (parts.length > 2) {
      workingText = '${parts[0]}.${parts.sublist(1).join('')}';
    }

    // Limit decimal places
    if (parts.length == 2 && parts[1].length > decimalDigits) {
      parts[1] = parts[1].substring(0, decimalDigits);
      workingText = '${parts[0]}.${parts[1]}';
    }

    // Format with thousand separators
    String formattedText = _addThousandSeparators(workingText);

    // Add negative sign back if needed
    if (isNegative && formattedText != '0') {
      formattedText = '-$formattedText';
    }

    // Calculate cursor position
    int selectionIndex = formattedText.length;

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }

  String _addThousandSeparators(String value) {
    if (value.isEmpty) return value;

    // Split by decimal point
    List<String> parts = value.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';

    // Add thousand separators to integer part
    if (integerPart.length > 3) {
      final formatter = NumberFormat('#,###');
      final number = int.tryParse(integerPart);
      if (number != null) {
        integerPart = formatter.format(number);
      }
    }

    // Reconstruct the number
    if (decimalPart.isNotEmpty) {
      return integerPart + decimalSeparator + decimalPart;
    } else if (value.endsWith('.')) {
      return integerPart + decimalSeparator;
    } else {
      return integerPart;
    }
  }

  // Helper method to get clean numeric value
  static double? getNumericValue(String formattedText) {
    if (formattedText.isEmpty) return null;

    // Remove thousand separators and parse
    final cleanText = formattedText.replaceAll(',', '');
    return double.tryParse(cleanText);
  }

  // Helper method to get clean string value (without formatting)
  static String getCleanValue(String formattedText) {
    if (formattedText.isEmpty) return '';

    // Remove thousand separators but keep decimal point
    return formattedText.replaceAll(',', '');
  }
}

class CurrencyTextInputFormatter extends DecimalCurrencyFormatter {
  CurrencyTextInputFormatter({
    int? decimalDigits,
    bool? enableNegative,
    String? thousandSeparator,
    String? decimalSeparator,
  }) : super(
         decimalDigits: decimalDigits ?? 2,
         enableNegative: enableNegative ?? false,
         thousandSeparator: thousandSeparator ?? ',',
         decimalSeparator: decimalSeparator ?? '.',
       );
}
