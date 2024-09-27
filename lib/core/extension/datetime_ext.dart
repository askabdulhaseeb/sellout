import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String get dateOnly => DateFormat('dd/MM/yyyy').format(this);
}
