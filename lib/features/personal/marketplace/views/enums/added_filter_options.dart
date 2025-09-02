import 'package:intl/intl.dart';

enum AddedFilterOption {
  today(Duration(days: 1), 'today'),
  last7Days(Duration(days: 7), '7_days'),
  last30Days(Duration(days: 30), '30_days'),
  last90Days(Duration(days: 90), '90_days');

  final Duration duration;
  final String localizationKey;

  const AddedFilterOption(this.duration, this.localizationKey);
}

extension AddedFilterExtension on AddedFilterOption {
  String get localized => localizationKey;

  String get formattedDate {
    final DateTime date = DateTime.now().subtract(duration).toUtc();
    final DateFormat formatter =
        DateFormat('EEE MMM dd yyyy HH:mm:ss', 'en_US');
    return '${formatter.format(date)} GMT+0000';
  }
}
