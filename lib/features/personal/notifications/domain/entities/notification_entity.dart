import 'package:hive_ce/hive.dart';
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
}
