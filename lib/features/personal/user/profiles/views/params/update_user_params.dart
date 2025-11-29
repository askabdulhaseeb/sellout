import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../../core/widgets/phone_number/domain/entities/phone_number_entity.dart';
import '../../../../location/data/models/location_model.dart';
import '../../../../setting/setting_dashboard/data/models/privacy_setting_model.dart';
import '../../../../setting/setting_dashboard/data/models/time_away_model.dart';

class UpdateUserParams {
  UpdateUserParams({
    this.name,
    this.bio,
    this.phone,
    this.dob,
    this.privacyType,
    this.location,
    this.timeAway,
    this.privacySettings,
    this.twoFactorAuth,
    this.pushNotification,
    this.emailNotification,
    this.country,
    this.gender,
    this.language,
  });

  final String? name;
  final String? bio;
  final PhoneNumberEntity? phone;
  final DateTime? dob;
  final PrivacyType? privacyType; 
  final LocationModel? location;
  final TimeAwayModel? timeAway;
  final PrivacySettingsModel? privacySettings;
  final bool? twoFactorAuth;
  final bool? pushNotification;
  final bool? emailNotification;
  final String? country; 
  final String? gender;
  final String? language;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    // Basic fields
    if (name?.trim().isNotEmpty == true) {
      map['display_name'] = name!.trim();
    }

    if (bio?.trim().isNotEmpty == true) {
      map['bio'] = bio!.trim();
    }

    if (dob != null) {
      map['dob'] = dob!.toIso8601String();
    }
    if (country != null) {
      map['country_alpha_3'] = country;
    }
    if (gender?.trim().isNotEmpty == true) {
      map['gender'] = gender!.trim();
    }

// Language
    if (language?.trim().isNotEmpty == true) {
      map['language'] = language!.trim();
    }
    // Phone
    if (phone != null) {
      if (phone!.countryCode.trim().isNotEmpty) {
        map['country_code'] = phone!.countryCode.trim();
      }
      if (phone!.number.trim().isNotEmpty) {
        map['phone_number'] = phone!.number.trim();
      }
    }

    // Profile type
    if (privacyType != null) {
      map['profile_type'] = privacyType!.json.trim();
    }

    // Location
    if (location != null) {
      map['location'] = location!.toJson();
    }

    // Time away
    if (timeAway != null) {
      map['time_away'] = timeAway!.toJson();
    }

    // Privacy
    if (privacySettings != null) {
      map['privacy'] = privacySettings!.toJson();
    }

    // Security
    if (twoFactorAuth != null) {
      map['security'] = <String, bool>{
        'two_factor_authentication': twoFactorAuth!,
      };
    }

    // Notifications
    if (pushNotification != null || emailNotification != null) {
      map['notifications'] = <String, bool>{
        if (pushNotification != null) 'push_notification': pushNotification!,
        if (emailNotification != null) 'email_notification': emailNotification!,
      };
    }

    return map;
  }
}
