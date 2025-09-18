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
      clothesSizes: (fields[1] as List?)?.cast<DropdownOptionEntity>(),
      footSizes: (fields[2] as List?)?.cast<DropdownOptionEntity>(),
      clothes: fields[3] as SubCategoryEntity?,
      foot: fields[4] as SubCategoryEntity?,
      clothesBrands: (fields[5] as List?)?.cast<DropdownOptionDataEntity>(),
      footwearBrands: (fields[6] as List?)?.cast<DropdownOptionDataEntity>(),
      age: (fields[7] as List?)?.cast<DropdownOptionEntity>(),
      breed: (fields[8] as List?)?.cast<DropdownOptionEntity>(),
      pets: (fields[9] as List?)?.cast<DropdownOptionEntity>(),
      readyToLeave: (fields[10] as List?)?.cast<DropdownOptionEntity>(),
      bodyType: fields[11] as BodyTypeEntity?,
      vehicles: (fields[12] as List?)?.cast<DropdownOptionEntity>(),
      emissionStandards: (fields[13] as List?)?.cast<DropdownOptionEntity>(),
      fuelType: (fields[14] as List?)?.cast<DropdownOptionEntity>(),
      make: (fields[15] as List?)?.cast<DropdownOptionEntity>(),
      mileageUnit: (fields[16] as List?)?.cast<DropdownOptionEntity>(),
      transmission: (fields[17] as List?)?.cast<DropdownOptionEntity>(),
      energyRating: (fields[18] as List?)?.cast<DropdownOptionEntity>(),
      propertyType: (fields[19] as List?)?.cast<DropdownOptionEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, CategoriesEntity obj) {
    writer
      ..writeByte(20)
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
      ..write(obj.readyToLeave)
      ..writeByte(11)
      ..write(obj.bodyType)
      ..writeByte(12)
      ..write(obj.vehicles)
      ..writeByte(13)
      ..write(obj.emissionStandards)
      ..writeByte(14)
      ..write(obj.fuelType)
      ..writeByte(15)
      ..write(obj.make)
      ..writeByte(16)
      ..write(obj.mileageUnit)
      ..writeByte(17)
      ..write(obj.transmission)
      ..writeByte(18)
      ..write(obj.energyRating)
      ..writeByte(19)
      ..write(obj.propertyType);
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
