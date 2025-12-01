// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoriesEntityAdapter extends TypeAdapter<CategoriesEntity> {
  @override
  final typeId = 78;

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
      food: fields[5] as SubCategoryEntity?,
      drink: fields[6] as SubCategoryEntity?,
      clothesBrands: (fields[7] as List?)?.cast<DropdownOptionDataEntity>(),
      footwearBrands: (fields[8] as List?)?.cast<DropdownOptionDataEntity>(),
      age: (fields[9] as List?)?.cast<DropdownOptionEntity>(),
      breed: (fields[10] as List?)?.cast<ParentDropdownEntity>(),
      pets: (fields[11] as List?)?.cast<DropdownOptionEntity>(),
      readyToLeave: (fields[12] as List?)?.cast<DropdownOptionEntity>(),
      bodyType: (fields[13] as List?)?.cast<ParentDropdownEntity>(),
      vehicles: (fields[14] as List?)?.cast<DropdownOptionEntity>(),
      emissionStandards: (fields[15] as List?)?.cast<DropdownOptionEntity>(),
      fuelType: (fields[16] as List?)?.cast<DropdownOptionEntity>(),
      make: (fields[17] as List?)?.cast<DropdownOptionEntity>(),
      mileageUnit: (fields[18] as List?)?.cast<DropdownOptionEntity>(),
      transmission: (fields[19] as List?)?.cast<DropdownOptionEntity>(),
      energyRating: (fields[20] as List?)?.cast<DropdownOptionEntity>(),
      propertyType: (fields[21] as List?)?.cast<DropdownOptionEntity>(),
      services: (fields[22] as List?)?.cast<ServiceCategoryEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, CategoriesEntity obj) {
    writer
      ..writeByte(23)
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
      ..write(obj.food)
      ..writeByte(6)
      ..write(obj.drink)
      ..writeByte(7)
      ..write(obj.clothesBrands)
      ..writeByte(8)
      ..write(obj.footwearBrands)
      ..writeByte(9)
      ..write(obj.age)
      ..writeByte(10)
      ..write(obj.breed)
      ..writeByte(11)
      ..write(obj.pets)
      ..writeByte(12)
      ..write(obj.readyToLeave)
      ..writeByte(13)
      ..write(obj.bodyType)
      ..writeByte(14)
      ..write(obj.vehicles)
      ..writeByte(15)
      ..write(obj.emissionStandards)
      ..writeByte(16)
      ..write(obj.fuelType)
      ..writeByte(17)
      ..write(obj.make)
      ..writeByte(18)
      ..write(obj.mileageUnit)
      ..writeByte(19)
      ..write(obj.transmission)
      ..writeByte(20)
      ..write(obj.energyRating)
      ..writeByte(21)
      ..write(obj.propertyType)
      ..writeByte(22)
      ..write(obj.services);
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
