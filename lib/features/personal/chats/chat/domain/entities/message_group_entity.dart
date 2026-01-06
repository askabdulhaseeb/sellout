import '../../../chat_dashboard/domain/entities/messages/message_entity.dart';

/// Represents a group of messages that share the same date.
/// Used to organize messages with date dividers in the chat UI.
class MessageGroup {
  const MessageGroup({
    required this.date,
    required this.label,
    required this.messages,
  });

  /// The date this group represents (normalized to midnight).
  final DateTime date;

  /// The display label for this date group (e.g., "Today", "Yesterday", "Monday").
  final String label;

  /// Messages belonging to this date group, sorted oldest to newest.
  final List<MessageEntity> messages;

  /// Returns true if this group contains the given message.
  bool containsMessage(String messageId) {
    return messages.any((MessageEntity m) => m.messageId == messageId);
  }

  /// Creates a copy of this group with optional parameter overrides.
  MessageGroup copyWith({
    DateTime? date,
    String? label,
    List<MessageEntity>? messages,
  }) {
    return MessageGroup(
      date: date ?? this.date,
      label: label ?? this.label,
      messages: messages ?? this.messages,
    );
  }
}

/// Container for grouped messages with additional metadata.
/// Provides the complete data structure needed for rendering the message list.
class GroupedMessages {
  const GroupedMessages({
    required this.groups,
    this.unreadCount = 0,
    this.firstUnreadMessageId,
    this.totalMessageCount = 0,
  });

  /// List of message groups sorted by date (oldest first).
  final List<MessageGroup> groups;

  /// Number of unread messages in the conversation.
  final int unreadCount;

  /// ID of the first unread message (for scroll-to-unread functionality).
  final String? firstUnreadMessageId;

  /// Total count of all messages across all groups.
  final int totalMessageCount;

  /// Returns an empty GroupedMessages instance.
  static const GroupedMessages empty = GroupedMessages(
    groups: <MessageGroup>[],
  );

  /// Returns true if there are no messages.
  bool get isEmpty => groups.isEmpty;

  /// Returns true if there are messages.
  bool get isNotEmpty => groups.isNotEmpty;

  /// Gets all messages as a flat list (sorted oldest to newest).
  List<MessageEntity> get allMessages {
    return groups.expand((MessageGroup g) => g.messages).toList();
  }

  /// Finds the group containing a specific message.
  MessageGroup? findGroupForMessage(String messageId) {
    for (final MessageGroup group in groups) {
      if (group.containsMessage(messageId)) {
        return group;
      }
    }
    return null;
  }

  /// Creates a copy with optional parameter overrides.
  GroupedMessages copyWith({
    List<MessageGroup>? groups,
    int? unreadCount,
    String? firstUnreadMessageId,
    int? totalMessageCount,
  }) {
    return GroupedMessages(
      groups: groups ?? this.groups,
      unreadCount: unreadCount ?? this.unreadCount,
      firstUnreadMessageId: firstUnreadMessageId ?? this.firstUnreadMessageId,
      totalMessageCount: totalMessageCount ?? this.totalMessageCount,
    );
  }
}
