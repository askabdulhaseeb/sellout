import '../../domain/entities/notification_metadata_entity.dart';

class NotificationMetadataModel extends NotificationMetadataEntity {
  NotificationMetadataModel({
    required super.orderId,
    required super.trackId,
    required super.postId,
    required super.paymentDetail,
  });

  factory NotificationMetadataModel.fromMap(Map<String, dynamic> map) {
    return NotificationMetadataModel(
      orderId: map['order_id'] ?? '',
      trackId: map['track_id'] ?? '',
      postId: map['post_id'] ?? '',
      paymentDetail: Map<String, dynamic>.from(
          map['payment_detail'] ?? <dynamic, dynamic>{}),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'order_id': orderId,
      'track_id': trackId,
      'post_id': postId,
      'payment_detail': paymentDetail,
    };
  }
}
