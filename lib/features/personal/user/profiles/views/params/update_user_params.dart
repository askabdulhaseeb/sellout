import '../../../../setting/setting_dashboard/data/models/privacy_setting_model.dart';
import '../../../../setting/setting_dashboard/data/models/time_away_model.dart';

class UpdateUserParams {
  UpdateUserParams({
    this.name,
    this.bio,
    this.uid,
    this.twoFactorAuth,
    this.dob,
    this.pushNotification,
    this.emailNotification,
    this.privacySettings,
    this.timeAway,
  });

  final String? name;
  final String? bio;
  final String? uid;
  final bool? twoFactorAuth;
  final DateTime? dob;
  final bool? pushNotification;
  final bool? emailNotification;
  final PrivacySettingsModel? privacySettings;
  final TimeAwayModel? timeAway;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    // Basic values
    if (name?.isNotEmpty == true) map['display_name'] = name;
    if (bio?.isNotEmpty == true) map['bio'] = bio;

    // Security
    if (twoFactorAuth != null) {
      map['security'] = <String, bool>{
        'two_factor_authentication': twoFactorAuth!,
      };
    }

    // Date of birth
    if (dob != null) {
      map['dob'] = dob!.toIso8601String();
    }

    // Notifications
    if (pushNotification != null || emailNotification != null) {
      map['notifications'] = <String, bool>{
        if (pushNotification != null) 'push_notification': pushNotification!,
        if (emailNotification != null) 'email_notification': emailNotification!,
      };
    }

    // Privacy settings
    if (privacySettings != null) {
      map['privacy'] = privacySettings!.toJson();
    }

    // Time away
    if (timeAway != null) {
      map['time_away'] = timeAway!.toJson();
    }

    return map;
  }
}
