import 'package:hive/hive.dart';
import '../../../data/models/sub_category_model.dart';
import 'subentities/dropdown_option_entity.dart';
import 'subentities/dropdown_option_data_entity.dart';
part 'categories_entity.g.dart';

@HiveType(typeId: 74)
class CategoriesEntity {
  CategoriesEntity({
    this.items,
    this.clothesSizes,
    this.footSizes,
    this.clothes,
    this.foot,
    this.clothesBrands,
    this.footwearBrands,
    this.age,
    this.breed,
    this.pets,
    this.readyToLeave,
    // this.bodyType,
    this.vehicles,
    this.emissionStandards,
    this.fuelType,
    this.make,
    this.mileageUnit,
    this.transmission,
  });

  @HiveField(0)
  final SubCategoryEntity? items;

  @HiveField(1)
  final List<DropdownOptionDataEntity>? clothesSizes;

  @HiveField(2)
  final List<DropdownOptionDataEntity>? footSizes;

  @HiveField(3)
  final SubCategoryEntity? clothes;

  @HiveField(4)
  final SubCategoryEntity? foot;

  @HiveField(5)
  final List<DropdownOptionEntity>? clothesBrands;

  @HiveField(6)
  final List<DropdownOptionEntity>? footwearBrands;

  @HiveField(7)
  final List<DropdownOptionDataEntity>? age;

  @HiveField(8)
  final List<DropdownOptionDataEntity>? breed;

  @HiveField(9)
  final List<DropdownOptionDataEntity>? pets;

  @HiveField(10)
  final List<DropdownOptionDataEntity>? readyToLeave;

  // @HiveField(11)
  // final BodyTypeEntity? bodyType;

  @HiveField(12)
  final List<DropdownOptionEntity>? vehicles;

  @HiveField(13)
  final List<DropdownOptionEntity>? emissionStandards;

  @HiveField(14)
  final List<DropdownOptionEntity>? fuelType;

  @HiveField(15)
  final List<DropdownOptionEntity>? make;

  @HiveField(16)
  final List<DropdownOptionEntity>? mileageUnit;

  @HiveField(17)
  final List<DropdownOptionEntity>? transmission;

  CategoriesEntity copyWith({
    SubCategoryEntity? items,
    List<DropdownOptionDataEntity>? clothesSizes,
    List<DropdownOptionDataEntity>? footSizes,
    SubCategoryEntity? clothes,
    SubCategoryEntity? foot,
    List<DropdownOptionEntity>? clothesBrands,
    List<DropdownOptionEntity>? footwearBrands,
    List<DropdownOptionDataEntity>? age,
    List<DropdownOptionDataEntity>? breed,
    List<DropdownOptionDataEntity>? pets,
    List<DropdownOptionDataEntity>? readyToLeave,
    // BodyTypeEntity? bodyType,
    List<DropdownOptionEntity>? vehicles,
    List<DropdownOptionEntity>? emissionStandards,
    List<DropdownOptionEntity>? fuelType,
    List<DropdownOptionEntity>? make,
    List<DropdownOptionEntity>? mileageUnit,
    List<DropdownOptionEntity>? transmission,
  }) {
    return CategoriesEntity(
      items: items ?? this.items,
      clothesSizes: clothesSizes ?? this.clothesSizes,
      footSizes: footSizes ?? this.footSizes,
      clothes: clothes ?? this.clothes,
      foot: foot ?? this.foot,
      clothesBrands: clothesBrands ?? this.clothesBrands,
      footwearBrands: footwearBrands ?? this.footwearBrands,
      age: age ?? this.age,
      breed: breed ?? this.breed,
      pets: pets ?? this.pets,
      readyToLeave: readyToLeave ?? this.readyToLeave,
      // bodyType: bodyType ?? this.bodyType,
      vehicles: vehicles ?? this.vehicles,
      emissionStandards: emissionStandards ?? this.emissionStandards,
      fuelType: fuelType ?? this.fuelType,
      make: make ?? this.make,
      mileageUnit: mileageUnit ?? this.mileageUnit,
      transmission: transmission ?? this.transmission,
    );
  }
}
