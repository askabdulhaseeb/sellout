import 'package:hive_ce/hive.dart';
import '../../../../../core/enums/core/status_type.dart';
import 'notification_metadata_entity.dart';
part 'notification_entity.g.dart';

@HiveType(typeId: 65)
class NotificationEntity {
  NotificationEntity({
    required this.notificationId,
    required this.userId,
    required this.type,
    required this.title,
    required this.deliverTo,
    required this.message,
    required this.isViewed,
    required this.metadata,
    required this.notificationFor,
    required this.timestamps,
    this.orderContext,
    this.status,
  });

  @HiveField(0)
  final String notificationId;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final String title;

  @HiveField(4)
  final String deliverTo;

  @HiveField(5)
  final String message;

  @HiveField(6)
  final bool isViewed;

  @HiveField(7)
  final NotificationMetadataEntity metadata;

  @HiveField(8)
  final String notificationFor;

  @HiveField(9)
  final DateTime timestamps;

  @HiveField(10)
  final StatusType? status;

  @HiveField(11)
  final OrderContextEntity? orderContext;

  /// Convenience getters that delegate to metadata
  String? get postId => metadata.postId;
  String? get orderId => metadata.orderId;
  String? get chatId => metadata.chatId;
  String? get trackId => metadata.trackId;
  String? get senderId => metadata.senderId;
  String? get messageId => metadata.messageId;

  /// Helper getters for common checks
  bool get hasOrder => metadata.hasOrder;
  bool get hasPost => metadata.hasPost;
  bool get hasChat => metadata.hasChat;
  bool get isOrderNotification => type.toLowerCase().contains('order');
  bool get isChatNotification =>
      type.toLowerCase().contains('chat') ||
      type.toLowerCase().contains('message');

  /// Determine if a notification belongs to the seller based on payment detail.
  bool isSellerFor(String? localUserId) {
    final String? sellerId = metadata.paymentDetail?.sellerId;
    if (sellerId == null || sellerId.isEmpty) return false;
    if (localUserId == null || localUserId.isEmpty) return false;
    return sellerId == localUserId;
  }
}

@HiveType(typeId: 97)
class OrderContextEntity {
  const OrderContextEntity({
    required this.postId,
    required this.buyerId,
    required this.orderId,
    required this.trackId, required this.sellerId, this.businessId,
  });
  @HiveField(0)
  final String postId;
  @HiveField(1)
  final String buyerId;
  @HiveField(2)
  final String orderId;
  @HiveField(3)
  final String? businessId;
  @HiveField(4)
  final String trackId;
  @HiveField(5)
  final String sellerId;
}
//         "order_context": {
//             "post_id": "c609bea2-9b89-40bb-a9f9-f4775475ca04-PL",
//             "buyer_id": "de528e11-0d96-49fe-b890-3c0b1809fcf9-U",
//             "order_id": "Test-ORD-10eb5e03-7c44-4af0-bc9f-83f087e10e31",
//             "business_id": null,
//             "track_id": "df99b9c3-691b-48fa-887c-367cf5a08083",
//             "seller_id": "cbd0b3a2-c337-4f01-9d72-9b4ed6354952-U"
//         },