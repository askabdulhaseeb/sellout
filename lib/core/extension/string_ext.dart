import 'package:intl/intl.dart';

extension StringExt on String {
  DateTime toLocalDate() {
    final DateFormat dateFormat = DateFormat("EEE MMM dd yyyy HH:mm:ss 'GMT'Z");
    DateTime dateTime = dateFormat.parse(this, true).toLocal();
    return dateTime;
  }
}
