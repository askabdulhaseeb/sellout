// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttachmentEntityAdapter extends TypeAdapter<AttachmentEntity> {
  @override
  final typeId = 4;

  @override
  AttachmentEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttachmentEntity(
      createdAt: fields[0] as DateTime,
      type: fields[1] as AttachmentType,
      url: fields[2] as String,
      originalName: fields[3] as String,
      fileId: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AttachmentEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.createdAt)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.url)
      ..writeByte(3)
      ..write(obj.originalName)
      ..writeByte(4)
      ..write(obj.fileId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttachmentEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
