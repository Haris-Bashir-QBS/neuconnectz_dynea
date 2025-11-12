import 'package:intl/intl.dart';

extension NumberExtensions on num? {
  /// Returns the value if > 1, otherwise returns 1
  num oneOrValue() {
    final value = this ?? 0;
    return value > 1 ? value : 1;
  }
}

extension StringExtensions on num {
  String get formatWithCommas {
    final formatter = NumberFormat('#,##0.###', 'en_US');
    return formatter.format(this);
  }
}

extension QuantityFormatter on double {
  String formatQuantity() {
    return this % 1 == 0 ? toInt().toString() : toStringAsFixed(8);
  }
}
