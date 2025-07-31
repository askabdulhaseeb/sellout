import 'package:hive/hive.dart';
part 'notification_metadata_entity.g.dart';

@HiveType(typeId: 66)
class NotificationMetadataEntity {
  NotificationMetadataEntity({
    required this.orderId,
    required this.trackId,
    required this.postId,
    required this.paymentDetail,
  });

  @HiveField(0)
  final String orderId;

  @HiveField(1)
  final String trackId;

  @HiveField(2)
  final String postId;

  @HiveField(3)
  final Map<String, dynamic> paymentDetail; // or create another entity for it
}
