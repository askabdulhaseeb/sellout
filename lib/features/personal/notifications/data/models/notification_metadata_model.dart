import '../../../../../core/enums/core/status_type.dart';
import '../../domain/entities/notification_metadata_entity.dart';

class NotificationMetadataModel extends NotificationMetadataEntity {
  NotificationMetadataModel({
    super.postId,
    super.orderId,
    super.chatId,
    super.trackId,
    super.senderId,
    super.messageId,
    super.status,
    super.createdAt,
  });

  factory NotificationMetadataModel.fromMap(Map<String, dynamic> map) {
    final String? statusRaw = _asStringOrNull(
      map['status'] ?? map['order_status'],
    );
    return NotificationMetadataModel(
      postId: _asStringOrNull(map['post_id']),
      orderId: _asStringOrNull(map['order_id']),
      chatId: _asStringOrNull(map['chat_id']),
      trackId: _asStringOrNull(map['track_id']),
      senderId: _asStringOrNull(map['sender']),
      messageId: _asStringOrNull(map['message_id']),
      status: statusRaw != null ? StatusType.fromJson(statusRaw) : null,
      createdAt: _asDateTimeOrNull(map['created_at'] ?? map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (postId != null) 'post_id': postId,
      if (orderId != null) 'order_id': orderId,
      if (chatId != null) 'chat_id': chatId,
      if (trackId != null) 'track_id': trackId,
      if (senderId != null) 'sender': senderId,
      if (messageId != null) 'message_id': messageId,
      if (status != null) 'status': status!.json,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  static String? _asStringOrNull(dynamic value) {
    if (value == null) return null;
    final String str = value.toString().trim();
    return str.isEmpty ? null : str;
  }

  static DateTime? _asDateTimeOrNull(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    if (value is num) {
      try {
        return DateTime.fromMillisecondsSinceEpoch(value.toInt());
      } catch (_) {}
    }
    return null;
  }
}
