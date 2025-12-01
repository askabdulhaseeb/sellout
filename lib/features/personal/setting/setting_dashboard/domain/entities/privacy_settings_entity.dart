import 'package:hive_ce/hive.dart';
part 'privacy_settings_entity.g.dart';

@HiveType(typeId: 63)
class PrivacySettingsEntity {
  const PrivacySettingsEntity({
    @HiveField(0) required this.thirdPartyTracking,
    @HiveField(1) required this.personalizedContent,
  });

  @HiveField(0)
  final bool? thirdPartyTracking;

  @HiveField(1)
  final bool? personalizedContent;

  PrivacySettingsEntity copyWith({
    bool? thirdPartyTracking,
    bool? personalizedContent,
  }) {
    return PrivacySettingsEntity(
      thirdPartyTracking: thirdPartyTracking ?? this.thirdPartyTracking,
      personalizedContent: personalizedContent ?? this.personalizedContent,
    );
  }
}
