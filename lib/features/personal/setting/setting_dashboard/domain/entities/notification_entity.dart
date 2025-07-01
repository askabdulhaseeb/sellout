import 'package:hive/hive.dart';
part 'notification_entity.g.dart';

@HiveType(typeId: 57)
class NotificationSettingsEntity {
  NotificationSettingsEntity({
    this.pushNotification,
    this.emailNotification,
  });

  @HiveField(0)
  bool? pushNotification;

  @HiveField(1)
  bool? emailNotification;

  NotificationSettingsEntity copyWith({
    bool? pushNotification,
    bool? emailNotification,
  }) {
    return NotificationSettingsEntity(
      pushNotification: pushNotification ?? this.pushNotification,
      emailNotification: emailNotification ?? this.emailNotification,
    );
  }
}
