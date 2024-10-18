// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_category_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubCategoryEntityAdapter extends TypeAdapter<SubCategoryEntity> {
  @override
  final int typeId = 8;

  @override
  SubCategoryEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubCategoryEntity(
      parent: fields[0] as String,
      title: fields[2] as String,
      listId: fields[3] as String,
      subCategory: (fields[4] as List).cast<SubCategoryEntity>(),
      cid: fields[5] as String,
      address: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SubCategoryEntity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.parent)
      ..writeByte(1)
      ..write(obj.address)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.listId)
      ..writeByte(4)
      ..write(obj.subCategory)
      ..writeByte(5)
      ..write(obj.cid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubCategoryEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
