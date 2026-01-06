import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../widgets/message/message_tile.dart';
import '../widgets/message/message_time_divider.dart';

class DateLabelHelper {
  static List<Widget> buildLabeledWidgets(
    List<MessageEntity> msgs,
    Map<String, Duration> timeDiffMap,
  ) {
    // sort oldest → newest
    msgs.sort((MessageEntity a, MessageEntity b) =>
        a.createdAt.compareTo(b.createdAt));

    final List<Widget> widgets = <Widget>[];
    String? lastLabel;

    for (final MessageEntity m in msgs) {
      final String label = _labelFor(m.createdAt);
      if (label != lastLabel) {
        widgets.add(MessageTimeDivider(label: label));
        lastLabel = label;
      }
      // Use ValueKey with messageId + updatedAt + fileStatus to ensure rebuild on updates
      final String keyValue =
          '${m.messageId}_${m.updatedAt.millisecondsSinceEpoch}_${m.fileStatus ?? ""}_${m.status?.code ?? ""}';
      widgets.add(
        MessageTile(
          key: ValueKey<String>(keyValue),
          message: m,
          timeDiff: timeDiffMap[m.messageId] ?? const Duration(days: 5),
        ),
      );
    }
    return widgets;
  }

  static String _labelFor(DateTime time) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime yesterday = today.subtract(const Duration(days: 1));
    final DateTime messageDate = DateTime(time.year, time.month, time.day);

    if (now.difference(time).inMinutes < 5 && messageDate == today) {
      return 'new_messages'.tr(); // you can also add key "now" in json
    }
    if (messageDate == today) return 'today'.tr();
    if (messageDate == yesterday) return 'yesterday'.tr();
    if (now.difference(messageDate).inDays < 7) {
      return _weekday(messageDate.weekday).tr();
    }
    // e.g. "12 August 2024"
    final int day = time.day;
    final String month = _month(time.month).tr();
    final int year = time.year;
    return '$day $month $year';
  }

  static String _weekday(int d) {
    const List<String> names = <String>[
      'sunday',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday'
    ];
    return names[d % 7];
  }

  static String _month(int m) {
    const List<String> months = <String>[
      '',
      'january',
      'february',
      'march',
      'april',
      'may',
      'june',
      'july',
      'august',
      'september',
      'october',
      'november',
      'december'
    ];
    return months[m];
  }
}
