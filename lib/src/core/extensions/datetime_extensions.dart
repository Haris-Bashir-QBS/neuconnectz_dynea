import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  String toDDMMYYFormat() {
    return DateFormat('dd-MM-yyyy').format(this);
  }
}


