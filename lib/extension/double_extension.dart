extension DoubleExtension on double {
  String toFormattedString() {
    String result = toStringAsFixed(2); // Format with two decimal places
    // Remove trailing zeros and decimal point if all decimal places are zeros
    result = result.contains('.')
        ? result.replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '')
        : result;
    return result;
  }
}
