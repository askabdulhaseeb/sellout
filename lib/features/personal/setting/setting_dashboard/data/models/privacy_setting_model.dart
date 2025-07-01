import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../domain/entities/privacy_settings_entity.dart';

class PrivacySettingsModel extends PrivacySettingsEntity {
  const PrivacySettingsModel({
    super.thirdPartyTracking,
    super.personalizedContent,
  });

  factory PrivacySettingsModel.fromJson(Map<String, dynamic> json) {
    return PrivacySettingsModel(
      thirdPartyTracking: json['third_party_tracking'] as bool? ?? false,
      personalizedContent: json['personalized_content'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'third_party_tracking': thirdPartyTracking == null
            ? LocalAuth.currentUser?.privacySettings?.thirdPartyTracking
            : thirdPartyTracking ?? false,
        'personalized_content': personalizedContent == null
            ? LocalAuth.currentUser?.privacySettings?.personalizedContent
            : personalizedContent ?? false,
      };
}
