// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoriesEntityAdapter extends TypeAdapter<CategoriesEntity> {
  @override
  final int typeId = 74;

  @override
  CategoriesEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoriesEntity(
      items: fields[0] as SubCategoryEntity?,
      clothesSizes: (fields[1] as List?)?.cast<DropdownOptionDataEntity>(),
      footSizes: (fields[2] as List?)?.cast<DropdownOptionDataEntity>(),
      clothes: fields[3] as SubCategoryEntity?,
      foot: fields[4] as SubCategoryEntity?,
      clothesBrands: (fields[5] as List?)?.cast<DropdownOptionEntity>(),
      footwearBrands: (fields[6] as List?)?.cast<DropdownOptionEntity>(),
      age: (fields[7] as List?)?.cast<DropdownOptionDataEntity>(),
      breed: (fields[8] as List?)?.cast<DropdownOptionDataEntity>(),
      pets: (fields[9] as List?)?.cast<DropdownOptionDataEntity>(),
      readyToLeave: (fields[10] as List?)?.cast<DropdownOptionDataEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, CategoriesEntity obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.items)
      ..writeByte(1)
      ..write(obj.clothesSizes)
      ..writeByte(2)
      ..write(obj.footSizes)
      ..writeByte(3)
      ..write(obj.clothes)
      ..writeByte(4)
      ..write(obj.foot)
      ..writeByte(5)
      ..write(obj.clothesBrands)
      ..writeByte(6)
      ..write(obj.footwearBrands)
      ..writeByte(7)
      ..write(obj.age)
      ..writeByte(8)
      ..write(obj.breed)
      ..writeByte(9)
      ..write(obj.pets)
      ..writeByte(10)
      ..write(obj.readyToLeave);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoriesEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
