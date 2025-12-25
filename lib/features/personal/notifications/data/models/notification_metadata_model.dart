import '../../../../../core/enums/core/status_type.dart';
import '../../domain/entities/notification_metadata_entity.dart';
import '../../../order/data/models/order_payment_detail_model.dart';

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
    super.paymentDetail,
  });

  factory NotificationMetadataModel.fromJson(Map<String, dynamic> json) {
    return NotificationMetadataModel(
      postId: json['postId'] as String?,
      orderId: json['orderId'] as String?,
      chatId: json['chatId'] as String?,
      trackId: json['trackId'] as String?,
      senderId: json['senderId'] as String?,
      messageId: json['messageId'] as String?,
      status: json['status'] as StatusType?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      paymentDetail: json['payment_detail'] != null
          ? OrderPaymentDetailModel.fromJson(
              json['payment_detail'] as Map<String, dynamic>,
            )
          : null,
    );
  }

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
      paymentDetail: map['payment_detail'] != null
          ? OrderPaymentDetailModel.fromJson(
              map['payment_detail'] as Map<String, dynamic>,
            )
          : null,
    );
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
