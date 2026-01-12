import 'dart:convert';
import '../../../../../core/enums/core/status_type.dart';
import '../../domain/entities/notification_entity.dart';
import 'notification_metadata_model.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.notificationId,
    required super.userId,
    required super.type,
    required super.title,
    required super.deliverTo,
    required super.message,
    required super.isViewed,
    required super.metadata,
    required super.notificationFor,
    required super.timestamps,
    super.orderContext,
    super.status,
  });

  factory NotificationModel.fromRawJson(String str) =>
      NotificationModel.fromMap(json.decode(str) as Map<String, dynamic>);

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    final Map<String, dynamic> metadataMap = _asStringKeyedMap(map['metadata']);
    final NotificationMetadataModel metadata =
        NotificationMetadataModel.fromMap(metadataMap);

    final dynamic timestampsValue =
        map['timestamps'] ?? map['timestamp'] ?? metadata.createdAt;

    final String? statusRaw = map['status']?.toString();

    return NotificationModel(
      notificationId: _asString(
        map['notification_id'] ?? map['notificationId'],
      ),
      userId: _asString(map['user_id'] ?? map['userId']),
      type: _asString(map['type']),
      title: _asString(map['title']),
      deliverTo: _asString(map['deliver_to'] ?? map['deliverTo']),
      message: _asString(map['message']),
      isViewed: _asBool(map['is_viewed'] ?? map['isViewed']),
      metadata: metadata,
      notificationFor: _asString(
        map['notification_for'] ?? map['notificationFor'],
      ),
      timestamps: _asDateTime(timestampsValue),
      status: statusRaw != null ? StatusType.fromJson(statusRaw) : null,
      orderContext: map['order_context'] == null
          ? null
          : OrderContextModel.fromMap(map['order_context']),
    );
  }

  static String _asString(dynamic value) => value?.toString() ?? '';

  static bool _asBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final String v = value.trim().toLowerCase();
      return v == 'true' || v == '1' || v == 'yes';
    }
    return false;
  }

  static Map<String, dynamic> _asStringKeyedMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  static DateTime _asDateTime(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    if (value is num) {
      try {
        return DateTime.fromMillisecondsSinceEpoch(value.toInt());
      } catch (_) {}
    }
    return DateTime.now();
  }
}

class OrderContextModel extends OrderContextEntity {
  const OrderContextModel({
    required super.postId,
    required super.buyerId,
    required super.orderId,
    super.businessId,
    required super.trackId,
    required super.sellerId,
  });
  factory OrderContextModel.fromRawJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json);
    return OrderContextModel.fromMap(map);
  }
  factory OrderContextModel.fromMap(Map<String, dynamic> map) {
    return OrderContextModel(
      postId: _asString(map['post_id']),
      buyerId: _asString(map['buyer_id']),
      orderId: _asString(map['order_id']),
      businessId: map['business_id']?.toString(),
      trackId: _asString(map['track_id']),
      sellerId: _asString(map['seller_id']),
    );
  }

  static String _asString(dynamic value) => value?.toString() ?? '';
}

//         "order_context": {
//             "post_id": "c609bea2-9b89-40bb-a9f9-f4775475ca04-PL",
//             "buyer_id": "de528e11-0d96-49fe-b890-3c0b1809fcf9-U",
//             "order_id": "Test-ORD-10eb5e03-7c44-4af0-bc9f-83f087e10e31",
//             "business_id": null,
//             "track_id": "df99b9c3-691b-48fa-887c-367cf5a08083",
//             "seller_id": "cbd0b3a2-c337-4f01-9d72-9b4ed6354952-U"
//         },
// [
//     {
//         "metadata": {
//             "quantity": 1,
//             "post_id": "c609bea2-9b89-40bb-a9f9-f4775475ca04-PL",
//             "total_amount": 120,
//             "track_id": "df99b9c3-691b-48fa-887c-367cf5a08083",
//             "currency": "GBP",
//             "item_title": "test item ",
//             "order_id": "Test-ORD-10eb5e03-7c44-4af0-bc9f-83f087e10e31"
//         },
//         "event": "order_placed",
//         "order_context": {
//             "post_id": "c609bea2-9b89-40bb-a9f9-f4775475ca04-PL",
//             "buyer_id": "de528e11-0d96-49fe-b890-3c0b1809fcf9-U",
//             "order_id": "Test-ORD-10eb5e03-7c44-4af0-bc9f-83f087e10e31",
//             "business_id": null,
//             "track_id": "df99b9c3-691b-48fa-887c-367cf5a08083",
//             "seller_id": "cbd0b3a2-c337-4f01-9d72-9b4ed6354952-U"
//         },
//         "notification_for": "personal",
//         "message": "Your order for test item  has been placed successfully",
//         "recipient_type": "buyer",
//         "requires_action": false,
//         "user_id": "de528e11-0d96-49fe-b890-3c0b1809fcf9-U",
//         "deliver_to": "de528e11-0d96-49fe-b890-3c0b1809fcf9-U",
//         "action_type": null,
//         "notification_id": "NT-8f4a0f3e-7543-47eb-be00-c557a49cbeb8",
//         "is_viewed": true,
//         "timestamps": "2026-01-12T13:57:17.191Z",
//         "title": "Order Confirmed",
//         "viewed_at": "2026-01-12T13:57:28.711Z",
//         "type": "order_placed"
//     }
// ]
