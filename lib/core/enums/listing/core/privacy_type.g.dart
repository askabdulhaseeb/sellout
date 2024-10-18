// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrivacyTypeAdapter extends TypeAdapter<PrivacyType> {
  @override
  final int typeId = 26;

  @override
  PrivacyType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PrivacyType.public;
      case 1:
        return PrivacyType.supporters;
      case 2:
        return PrivacyType.private;
      default:
        return PrivacyType.public;
    }
  }

  @override
  void write(BinaryWriter writer, PrivacyType obj) {
    switch (obj) {
      case PrivacyType.public:
        writer.writeByte(0);
        break;
      case PrivacyType.supporters:
        writer.writeByte(1);
        break;
      case PrivacyType.private:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrivacyTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
