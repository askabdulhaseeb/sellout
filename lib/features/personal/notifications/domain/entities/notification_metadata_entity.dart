import 'package:hive_ce/hive.dart';
import '../../../../../core/enums/core/status_type.dart';

part 'notification_metadata_entity.g.dart';

@HiveType(typeId: 66)
class NotificationMetadataEntity {
  NotificationMetadataEntity({
    this.postId,
    this.orderId,
    this.chatId,
    this.trackId,
    this.senderId,
    this.messageId,
    this.status,
    this.createdAt,
  });

  @HiveField(0)
  final String? postId;

  @HiveField(1)
  final String? orderId;

  @HiveField(2)
  final String? chatId;

  @HiveField(3)
  final String? trackId;

  @HiveField(4)
  final String? senderId;

  @HiveField(5)
  final String? messageId;

  @HiveField(6)
  final StatusType? status;

  @HiveField(7)
  final DateTime? createdAt;

  bool get hasOrder => orderId != null && orderId!.isNotEmpty;
  bool get hasPost => postId != null && postId!.isNotEmpty;
  bool get hasChat => chatId != null && chatId!.isNotEmpty;
}
