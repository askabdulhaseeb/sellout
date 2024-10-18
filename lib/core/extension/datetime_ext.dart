import 'package:easy_localization/easy_localization.dart';
extension DateTimeExt on DateTime {
  String get dateOnly => DateFormat('dd/MM/yyyy').format(this);

  String get timeOnly => DateFormat('hh:mm a').format(this);

  String get dateTime => DateFormat('dd/MM/yyyy HH:mm').format(this);

  String get timeAgo {
    final Duration diff = DateTime.now().difference(this);
    if (diff.inDays < 1) {
      return timeOnly;
    } else if (diff.inDays < 2) {
      return 'yesterday'.tr();
    } else if (diff.inDays < 7) {
      return DateFormat('EEEE').format(this);
    } else if (diff.inDays < 30) {
      return '${diff.inDays ~/ 7} ${diff.inDays ~/ 7 == 1 ? 'week-ago'.tr() : 'weeks-ago'.tr()}';
    } else if (diff.inDays < 365) {
      return '${diff.inDays ~/ 30} ${diff.inDays ~/ 30 == 1 ? 'month-ago'.tr() : 'months-ago'.tr()}';
    } else {
      return '${diff.inDays ~/ 365} ${diff.inDays ~/ 365 == 1 ? 'year-ago'.tr() : 'years-ago'.tr()}';
    }
  }
}
