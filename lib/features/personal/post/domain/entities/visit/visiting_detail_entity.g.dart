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
      visitingID: fields[0] as String,
      visiterID: fields[1] as String,
      businessID: fields[2] as String?,
      hostID: fields[3] as String,
      postID: fields[4] as String,
      status: fields[5] as StatusType,
      visitingTime: fields[6] as String,
      dateTime: fields[7] as DateTime,
      createdAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, VisitingDetailEntity obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.visitingID)
      ..writeByte(1)
      ..write(obj.visiterID)
      ..writeByte(2)
      ..write(obj.businessID)
      ..writeByte(3)
      ..write(obj.hostID)
      ..writeByte(4)
      ..write(obj.postID)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.visitingTime)
      ..writeByte(7)
      ..write(obj.dateTime)
      ..writeByte(8)
      ..write(obj.createdAt);
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
