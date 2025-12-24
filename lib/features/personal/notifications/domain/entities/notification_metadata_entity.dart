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
    this.recipients,
    this.paymentDetail,
    this.postageDetail,
    this.status,
    this.createdAt,
    this.rawData,
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
  final List<String>? recipients;

  @HiveField(7)
  final Map<String, dynamic>? paymentDetail;

  @HiveField(8)
  final Map<String, dynamic>? postageDetail;

  @HiveField(9)
  final StatusType? status;

  @HiveField(10)
  final DateTime? createdAt;

  /// Raw metadata for any additional fields
  @HiveField(11)
  final Map<String, dynamic>? rawData;

  bool get hasOrder => orderId != null && orderId!.isNotEmpty;
  bool get hasPost => postId != null && postId!.isNotEmpty;
  bool get hasChat => chatId != null && chatId!.isNotEmpty;
  bool get hasPayment => paymentDetail != null && paymentDetail!.isNotEmpty;
}
