import 'dart:convert';
import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  factory NotificationModel.fromRawJson(String str) =>
      NotificationModel.fromMap(json.decode(str));
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
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      notificationId: map['notification_id'] ?? '',
      userId: map['user_id'] ?? '',
      type: map['type'] ?? '',
      title: map['title'] ?? '',
      deliverTo: map['deliver_to'] ?? '',
      message: map['message'] ?? '',
      isViewed: map['is_viewed'] ?? false,
      metadata: map['metadata'] ?? <dynamic, dynamic>{},
      notificationFor: map['notification_for'] ?? '',
      timestamps: DateTime.tryParse(map['timestamps'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notification_id': notificationId,
      'user_id': userId,
      'type': type,
      'title': title,
      'deliver_to': deliverTo,
      'message': message,
      'is_viewed': isViewed,
      'metadata': metadata,
      'notification_for': notificationFor,
      'timestamps': timestamps.toIso8601String(),
    };
  }

  String toRawJson() => json.encode(toMap());
}
