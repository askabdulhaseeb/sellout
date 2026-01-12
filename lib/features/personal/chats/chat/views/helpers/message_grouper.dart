import 'package:easy_localization/easy_localization.dart';
import '../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../domain/entities/message_group_entity.dart';

/// Groups messages by date and provides cached computation.
/// Returns pure data structures instead of widgets for better separation of concerns.
class MessageGrouper {
  MessageGrouper();

  // Cache for grouped messages
  GroupedMessages? _cachedResult;
  String? _lastCacheKey;

  /// Groups messages by date with caching.
  /// Returns cached result if messages haven't changed.
  GroupedMessages groupMessages(List<MessageEntity> messages) {
    if (messages.isEmpty) {
      return GroupedMessages.empty;
    }

    final String cacheKey = _buildCacheKey(messages);
    if (cacheKey == _lastCacheKey && _cachedResult != null) {
      return _cachedResult!;
    }

    _cachedResult = _computeGroups(messages);
    _lastCacheKey = cacheKey;
    return _cachedResult!;
  }

  /// Clears the cache, forcing recomputation on next call.
  void clearCache() {
    _cachedResult = null;
    _lastCacheKey = null;
  }

  /// Builds a cache key from messages for change detection.
  String _buildCacheKey(List<MessageEntity> messages) {
    final StringBuffer buffer = StringBuffer();
    for (final MessageEntity m in messages) {
      // Include fields that affect grouping or display
      buffer.write(
        '${m.messageId}:${m.updatedAt.millisecondsSinceEpoch}:${m.status?.code ?? ""}:${m.fileStatus ?? ""}|',
      );
    }
    return buffer.toString();
  }

  /// Computes message groups from a list of messages.
  GroupedMessages _computeGroups(List<MessageEntity> messages) {
    // Sort messages oldest to newest
    final List<MessageEntity> sortedMessages = List<MessageEntity>.from(messages)
      ..sort((MessageEntity a, MessageEntity b) =>
          a.createdAt.compareTo(b.createdAt));

    // Group messages by date
    final Map<DateTime, List<MessageEntity>> grouped =
        <DateTime, List<MessageEntity>>{};

    for (final MessageEntity message in sortedMessages) {
      final DateTime dateKey = DateTime(
        message.createdAt.year,
        message.createdAt.month,
        message.createdAt.day,
      );
      grouped.putIfAbsent(dateKey, () => <MessageEntity>[]).add(message);
    }

    // Convert to MessageGroup list
    final List<MessageGroup> groups = grouped.entries
        .map((MapEntry<DateTime, List<MessageEntity>> entry) => MessageGroup(
              date: entry.key,
              label: _computeLabel(entry.key),
              messages: entry.value,
            ))
        .toList()
      ..sort((MessageGroup a, MessageGroup b) => a.date.compareTo(b.date));

    return GroupedMessages(
      groups: groups,
      totalMessageCount: sortedMessages.length,
      unreadCount: _countUnread(sortedMessages),
      firstUnreadMessageId: _findFirstUnread(sortedMessages),
    );
  }

  /// Computes the display label for a date.
  String _computeLabel(DateTime date) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime yesterday = today.subtract(const Duration(days: 1));

    // Check if date is within last 5 minutes (for "new messages" label)
    if (now.difference(date).inMinutes < 5 && date.day == today.day) {
      return 'new_messages'.tr();
    }

    if (date == today) return 'today'.tr();
    if (date == yesterday) return 'yesterday'.tr();

    // Within last week - show weekday name
    if (now.difference(date).inDays < 7) {
      return _weekday(date.weekday).tr();
    }

    // Older dates - show full date
    final String month = _month(date.month).tr();
    return '${date.day} $month ${date.year}';
  }

  /// Returns the weekday translation key.
  String _weekday(int weekday) {
    const List<String> names = <String>[
      'sunday',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
    ];
    return names[weekday % 7];
  }

  /// Returns the month translation key.
  String _month(int month) {
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
      'december',
    ];
    return months[month];
  }

  /// Counts unread messages.
  /// TODO: Implement based on read receipts when available.
  int _countUnread(List<MessageEntity> messages) {
    // Placeholder - implement based on your read receipt logic
    return 0;
  }

  /// Finds the first unread message ID.
  /// TODO: Implement based on read receipts when available.
  String? _findFirstUnread(List<MessageEntity> messages) {
    // Placeholder - implement based on your read receipt logic
    return null;
  }
}

/// Computes time differences between consecutive messages from the same sender.
/// Used to determine when to show sender name and timestamp.
class MessageTimeDiffCalculator {
  /// Calculates time differences for each message.
  /// Returns a map of messageId -> Duration to next message from same sender.
  static Map<String, Duration> calculateTimeDiffs(List<MessageEntity> messages) {
    final Map<String, Duration> timeDiffMap = <String, Duration>{};

    // Sort oldest to newest
    final List<MessageEntity> sorted = List<MessageEntity>.from(messages)
      ..sort((MessageEntity a, MessageEntity b) =>
          a.createdAt.compareTo(b.createdAt));

    for (int i = 0; i < sorted.length; i++) {
      final MessageEntity current = sorted[i];
      final MessageEntity? next = i < sorted.length - 1 ? sorted[i + 1] : null;

      // Calculate diff to next message from same sender
      final Duration diff = (next != null && current.sendBy == next.sendBy)
          ? next.createdAt.difference(current.createdAt).abs()
          : const Duration(days: 5); // Large duration if no next message

      timeDiffMap[current.messageId] = diff;
    }

    return timeDiffMap;
  }

  /// Determines if sender name should be shown for a message.
  static bool shouldShowSenderName(
    MessageEntity current,
    MessageEntity? previous,
  ) {
    if (previous == null) return true;
    return current.sendBy != previous.sendBy;
  }

  /// Determines if timestamp should be shown for a message.
  /// Shows timestamp if more than 5 minutes since previous message.
  static bool shouldShowTimestamp(
    MessageEntity current,
    MessageEntity? previous,
  ) {
    if (previous == null) return true;
    return current.createdAt.difference(previous.createdAt).inMinutes > 5;
  }
}
