// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_settings_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrivacySettingsEntityAdapter extends TypeAdapter<PrivacySettingsEntity> {
  @override
  final typeId = 63;

  @override
  PrivacySettingsEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrivacySettingsEntity(
      thirdPartyTracking: fields[0] as bool?,
      personalizedContent: fields[1] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, PrivacySettingsEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.thirdPartyTracking)
      ..writeByte(1)
      ..write(obj.personalizedContent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrivacySettingsEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
