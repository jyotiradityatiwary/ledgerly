import 'dart:math' as math;

String formatCurrency({
  required final int magnitude,
  required final int precision,
  required final String currency,
}) =>
    '$currency ${magnitude.toDouble() / math.pow(10, precision)}';
