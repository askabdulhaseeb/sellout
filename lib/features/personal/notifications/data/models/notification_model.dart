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
    return DateTime.now();
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    final Map<String, dynamic> metadata = _asStringKeyedMap(map['metadata']);
    final dynamic timestampsValue =
        map['timestamps'] ?? map['timestamp'] ?? metadata['created_at'];

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
