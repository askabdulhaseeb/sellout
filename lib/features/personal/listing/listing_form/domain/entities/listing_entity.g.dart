// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ListingEntityAdapter extends TypeAdapter<ListingEntity> {
  @override
  final int typeId = 7;

  @override
  ListingEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListingEntity(
      listId: fields[0] as String,
      subCategory: (fields[1] as List).cast<SubCategoryEntity>(),
      parent: fields[2] as String,
      isActive: fields[4] as bool,
      cid: fields[5] as String,
      title: fields[6] as String,
      type: fields[7] as ListingType,
      address: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ListingEntity obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.listId)
      ..writeByte(1)
      ..write(obj.subCategory)
      ..writeByte(2)
      ..write(obj.parent)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.isActive)
      ..writeByte(5)
      ..write(obj.cid)
      ..writeByte(6)
      ..write(obj.title)
      ..writeByte(7)
      ..write(obj.type)
      ..writeByte(8)
      ..write(obj.inHiveAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListingEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
