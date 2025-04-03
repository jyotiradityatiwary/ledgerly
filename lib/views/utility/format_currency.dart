import 'dart:math' as math;

String formatCurrency({
  required final int magnitude,
  required final int maxPrecision,
  required final String? currency,
}) {
  final int displayPrecision = maxPrecision - 1;
  final double displayValue =
      magnitude.toDouble() / math.pow(10.0, displayPrecision);
  return currency == null ? displayValue.toString() : '$currency $displayValue';
}
