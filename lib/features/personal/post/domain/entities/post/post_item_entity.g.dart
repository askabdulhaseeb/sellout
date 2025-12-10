// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_item_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostItemEntityAdapter extends TypeAdapter<PostItemEntity> {
  @override
  final typeId = 73;

  @override
  PostItemEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostItemEntity(address: fields[1] as String?);
  }

  @override
  void write(BinaryWriter writer, PostItemEntity obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostItemEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
