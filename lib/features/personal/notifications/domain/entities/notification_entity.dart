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

  /// Convenience getters that delegate to metadata
  String? get postId => metadata.postId;
  String? get orderId => metadata.orderId;
  String? get chatId => metadata.chatId;
  String? get trackId => metadata.trackId;
  String? get senderId => metadata.senderId;
  String? get messageId => metadata.messageId;
  List<String>? get recipients => metadata.recipients;
  Map<String, dynamic>? get paymentDetail => metadata.paymentDetail;
  Map<String, dynamic>? get postageDetail => metadata.postageDetail;

  /// Helper getters for common checks
  bool get hasOrder => metadata.hasOrder;
  bool get hasPost => metadata.hasPost;
  bool get hasChat => metadata.hasChat;
  bool get hasPayment => metadata.hasPayment;
  bool get isOrderNotification => type.toLowerCase().contains('order');
  bool get isChatNotification =>
      type.toLowerCase().contains('chat') ||
      type.toLowerCase().contains('message');
}
