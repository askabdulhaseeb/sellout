import 'package:hive_ce/hive.dart';
import '../../../../../core/enums/core/status_type.dart';
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
    required this.status,
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
  final Map<String, dynamic> metadata;

  @HiveField(8)
  final String notificationFor;

  @HiveField(9)
  final DateTime timestamps;

  /// Typed status for notifications that carry a status update (e.g. order status).
  /// Defaults to [StatusType.pending] when not provided.
  @HiveField(10)
  final StatusType status;

  String? get chatId => metadata['chat_id']?.toString();
  String? get postId => metadata['post_id']?.toString();
  String? get orderId => metadata['order_id']?.toString();
  String? get bookingId => metadata['booking_id']?.toString();

  DateTime? get createdAt {
    final dynamic value = metadata['created_at'];
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  NotificationEntity copyWith({
    String? notificationId,
    String? userId,
    String? type,
    String? title,
    String? deliverTo,
    String? message,
    bool? isViewed,
    Map<String, dynamic>? metadata,
    String? notificationFor,
    DateTime? timestamps,
    StatusType? status,
  }) {
    return NotificationEntity(
      notificationId: notificationId ?? this.notificationId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      deliverTo: deliverTo ?? this.deliverTo,
      message: message ?? this.message,
      isViewed: isViewed ?? this.isViewed,
      metadata: metadata ?? this.metadata,
      notificationFor: notificationFor ?? this.notificationFor,
      timestamps: timestamps ?? this.timestamps,
      status: status ?? this.status,
    );
  }
}
