// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supporter_detail_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SupporterDetailEntityAdapter extends TypeAdapter<SupporterDetailEntity> {
  @override
  final typeId = 36;

  @override
  SupporterDetailEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SupporterDetailEntity(
      userID: fields[0] as String,
      supportingTime: fields[1] as DateTime,
      status: fields[2] as StatusType,
    );
  }

  @override
  void write(BinaryWriter writer, SupporterDetailEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userID)
      ..writeByte(1)
      ..write(obj.supportingTime)
      ..writeByte(2)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupporterDetailEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
