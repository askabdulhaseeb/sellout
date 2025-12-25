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
