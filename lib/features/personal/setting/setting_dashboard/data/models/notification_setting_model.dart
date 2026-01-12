import '../../domain/entities/notification_setting_entity.dart';

class NotificationSettingsModel extends NotificationSettingsEntity {
  factory NotificationSettingsModel.fromMap(Map<String, dynamic> map) {
    return NotificationSettingsModel(
      pushNotification: map['push_notification'] ?? false,
      emailNotification: map['email_notification'] ?? false,
    );
  }
  factory NotificationSettingsModel.fromEntity(
      NotificationSettingsEntity entity) {
    return NotificationSettingsModel(
      pushNotification: entity.pushNotification,
      emailNotification: entity.emailNotification,
    );
  }
  NotificationSettingsModel({
    super.pushNotification,
    super.emailNotification,
  });
}
