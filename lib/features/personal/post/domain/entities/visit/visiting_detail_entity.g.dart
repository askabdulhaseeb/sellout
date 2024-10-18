// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visiting_detail_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VisitingDetailEntityAdapter extends TypeAdapter<VisitingDetailEntity> {
  @override
  final int typeId = 14;

  @override
  VisitingDetailEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VisitingDetailEntity(
      visitingId: fields[0] as String,
      post: fields[1] as VisitingDetailPostEntity,
      dateTime: fields[2] as DateTime,
      visiterId: fields[3] as String,
      visitingTime: fields[4] as String,
      hostId: fields[5] as String,
      status: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VisitingDetailEntity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.visitingId)
      ..writeByte(1)
      ..write(obj.post)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.visiterId)
      ..writeByte(4)
      ..write(obj.visitingTime)
      ..writeByte(5)
      ..write(obj.hostId)
      ..writeByte(6)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisitingDetailEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
