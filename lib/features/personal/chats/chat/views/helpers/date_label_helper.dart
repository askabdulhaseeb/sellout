import 'package:flutter/material.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../domain/entities/message_group_entity.dart';
import '../widgets/message/message_tile.dart';
import '../widgets/message/message_time_divider.dart';
import 'message_grouper.dart';

/// Helper class for building message list widgets with date labels.
/// Uses MessageGrouper for data transformation and handles widget creation.
class DateLabelHelper {
  /// Singleton MessageGrouper instance for caching across calls.
  static final MessageGrouper _grouper = MessageGrouper();

  /// Builds widgets from messages with date dividers.
  /// Uses cached grouping from MessageGrouper for performance.
  static List<Widget> buildLabeledWidgets(
    List<MessageEntity> msgs,
    Map<String, Duration> timeDiffMap,
  ) {
    if (msgs.isEmpty) return <Widget>[];

    // Use MessageGrouper for cached date grouping
    final GroupedMessages grouped = _grouper.groupMessages(msgs);

    final List<Widget> widgets = <Widget>[];

    for (final MessageGroup group in grouped.groups) {
      // Add date divider at the start of each group
      widgets.add(MessageTimeDivider(label: group.label));

      // Add message tiles for this group
      for (final MessageEntity m in group.messages) {
        widgets.add(_buildMessageTile(m, timeDiffMap));
      }
    }

    return widgets;
  }

  /// Builds a single message tile with proper key for efficient updates.
  static Widget _buildMessageTile(
    MessageEntity m,
    Map<String, Duration> timeDiffMap,
  ) {
    // Include fileUrl in key for audio/document messages that update after upload
    final String fileUrlHash = m.fileUrl.isNotEmpty
        ? m.fileUrl.map((AttachmentEntity f) => f.url).join(',')
        : '';
    final String keyValue =
        '${m.messageId}_${m.updatedAt.millisecondsSinceEpoch}_${m.fileStatus ?? ""}_${m.status?.code ?? ""}_$fileUrlHash';

    return MessageTile(
      key: ValueKey<String>(keyValue),
      message: m,
      timeDiff: timeDiffMap[m.messageId] ?? const Duration(days: 5),
    );
  }

  /// Clears the grouper cache. Call when chat changes.
  static void clearCache() {
    _grouper.clearCache();
  }
}
