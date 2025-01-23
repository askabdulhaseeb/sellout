import 'package:easy_localization/easy_localization.dart';

extension DateTimeExt on DateTime {
  String get dateOnly => DateFormat('dd/MM/yyyy').format(this);
  String get dateWithFullMonth =>
      '$monthFullName ${DateFormat('dd, yyyy').format(this)}';
  String get monthFullName =>
      DateFormat('MMMM').format(this).toLowerCase().tr();

  String get dateWithMonthOnly {
    // Use DateFormat to format the date
    String daySuffix(int day) {
      if (day >= 11 && day <= 13) {
        return 'th';
      }
      switch (day % 10) {
        case 1:
          return 'st';
        case 2:
          return 'nd';
        case 3:
          return 'rd';
        default:
          return 'th';
      }
    }

    String formattedDate = DateFormat('d MMM yyyy').format(this);
    return formattedDate.replaceFirst(RegExp(r'\d+'), '$day${daySuffix(day)}');
  }

  String get timeOnly => DateFormat('hh:mm a').format(this);

  String get dateTime => DateFormat('dd/MM/yyyy HH:mm a').format(this);

  String get zTypeDateTime =>
      DateFormat('yyyy-MM-ddTHH:mm:ss.mmmZ').format(this);

  String get timeAgo {
    final Duration diff = DateTime.now().difference(this);
    if (diff.inDays < 1) {
      return timeOnly;
    } else if (diff.inDays < 2) {
      return 'yesterday'.tr();
    } else if (diff.inDays < 7) {
      return DateFormat('EEEE').format(this).toLowerCase().tr();
    } else if (diff.inDays < 30) {
      return '${diff.inDays ~/ 7} ${diff.inDays ~/ 7 == 1 ? 'week_ago'.tr() : 'weeks_ago'.tr()}';
    } else if (diff.inDays < 365) {
      return '${diff.inDays ~/ 30} ${diff.inDays ~/ 30 == 1 ? 'month_ago'.tr() : 'months_ago'.tr()}';
    } else {
      return '${diff.inDays ~/ 365} ${diff.inDays ~/ 365 == 1 ? 'year_ago'.tr() : 'years_ago'.tr()}';
    }
  }

  String get messageTime {
    final Duration diff = DateTime.now().difference(this);
    if (diff.inDays < 1) {
      return timeOnly;
    } else if (diff.inDays < 2) {
      return '${'yesterday'.tr()} $timeOnly';
    } else if (diff.inDays < 7) {
      return '${DateFormat('EEEE').format(this).toLowerCase().tr()} $timeOnly';
    } else if (diff.inDays < 365) {
      return '${DateFormat('dd').format(this)} ${DateFormat('MMM').format(this).toLowerCase().tr()} $timeOnly';
    } else {
      return '${DateFormat('dd').format(this)} ${DateFormat('MMM').format(this).toLowerCase().tr()} ${DateFormat('yyyy HH:mm a').format(this).toLowerCase().tr()}';
    }
  }
}
