import '../../domain/entities/notification_metadata_entity.dart';

class NotificationMetadataModel extends NotificationMetadataEntity {
  NotificationMetadataModel({
    super.postId,
    super.orderId,
    super.chatId,
    super.trackId,
    super.senderId,
    super.messageId,
    super.recipients,
    super.paymentDetail,
    super.postageDetail,
    super.status,
    super.createdAt,
    super.rawData,
  });

  factory NotificationMetadataModel.fromMap(Map<String, dynamic> map) {
    return NotificationMetadataModel(
      postId: _asStringOrNull(map['post_id']),
      orderId: _asStringOrNull(map['order_id']),
      chatId: _asStringOrNull(map['chat_id']),
      trackId: _asStringOrNull(map['track_id']),
      senderId: _asStringOrNull(map['sender']),
      messageId: _asStringOrNull(map['message_id']),
      recipients: _asStringList(map['recipients']),
      paymentDetail: _asStringKeyedMapOrNull(map['payment_detail']),
      postageDetail: _asStringKeyedMapOrNull(map['postage_detail']),
      status: _asStringOrNull(
        map['status'] ??
            map['order_status'] ??
            map['payment_detail']?['status'],
      ),
      createdAt: _asDateTimeOrNull(map['created_at'] ?? map['timestamp']),
      rawData: Map<String, dynamic>.from(map),
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
      if (recipients != null) 'recipients': recipients,
      if (paymentDetail != null) 'payment_detail': paymentDetail,
      if (postageDetail != null) 'postage_detail': postageDetail,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      ...?rawData,
    };
  }

  static String? _asStringOrNull(dynamic value) {
    if (value == null) return null;
    final String str = value.toString().trim();
    return str.isEmpty ? null : str;
  }

  static Map<String, dynamic>? _asStringKeyedMapOrNull(dynamic value) {
    if (value == null) return null;
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static List<String>? _asStringList(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return null;
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
