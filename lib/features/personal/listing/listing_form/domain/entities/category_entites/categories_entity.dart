import 'package:hive/hive.dart';
import '../../../data/models/sub_category_model.dart';
import 'subentities/parent_dropdown_entity.dart';
import 'subentities/dropdown_option_data_entity.dart';
import 'subentities/dropdown_option_entity.dart';
part 'categories_entity.g.dart';

@HiveType(typeId: 74)
class CategoriesEntity {
  CategoriesEntity({
    this.items,
    this.clothesSizes,
    this.footSizes,
    this.clothes,
    this.foot,
    this.food,
    this.drink,
    this.clothesBrands,
    this.footwearBrands,
    this.age,
    this.breed,
    this.pets,
    this.readyToLeave,
    this.bodyType,
    this.vehicles,
    this.emissionStandards,
    this.fuelType,
    this.make,
    this.mileageUnit,
    this.transmission,
    this.energyRating,
    this.propertyType,
  });

  // ✅ Category groups
  @HiveField(0)
  final SubCategoryEntity? items;

  @HiveField(1)
  final List<DropdownOptionEntity>? clothesSizes;

  @HiveField(2)
  final List<DropdownOptionEntity>? footSizes;

  @HiveField(3)
  final SubCategoryEntity? clothes;

  @HiveField(4)
  final SubCategoryEntity? foot;

  @HiveField(5)
  final SubCategoryEntity? food;

  @HiveField(6)
  final SubCategoryEntity? drink;

  @HiveField(7)
  final List<DropdownOptionDataEntity>? clothesBrands;

  @HiveField(8)
  final List<DropdownOptionDataEntity>? footwearBrands;

  @HiveField(9)
  final List<DropdownOptionEntity>? age;

  @HiveField(10)
  final List<ParentDropdownEntity>? breed;

  @HiveField(11)
  final List<DropdownOptionEntity>? pets;

  @HiveField(12)
  final List<DropdownOptionEntity>? readyToLeave;

  @HiveField(13)
  final List<ParentDropdownEntity>? bodyType;

  @HiveField(14)
  final List<DropdownOptionEntity>? vehicles;

  @HiveField(15)
  final List<DropdownOptionEntity>? emissionStandards;

  @HiveField(16)
  final List<DropdownOptionEntity>? fuelType;

  @HiveField(17)
  final List<DropdownOptionEntity>? make;

  @HiveField(18)
  final List<DropdownOptionEntity>? mileageUnit;

  @HiveField(19)
  final List<DropdownOptionEntity>? transmission;

  @HiveField(20)
  final List<DropdownOptionEntity>? energyRating;

  @HiveField(21)
  final List<DropdownOptionEntity>? propertyType;

  // ✅ CopyWith method
  CategoriesEntity copyWith({
    SubCategoryEntity? items,
    List<DropdownOptionEntity>? clothesSizes,
    List<DropdownOptionEntity>? footSizes,
    SubCategoryEntity? clothes,
    SubCategoryEntity? foot,
    SubCategoryEntity? food,
    SubCategoryEntity? drink,
    List<DropdownOptionDataEntity>? clothesBrands,
    List<DropdownOptionDataEntity>? footwearBrands,
    List<DropdownOptionEntity>? age,
    List<ParentDropdownEntity>? breed,
    List<DropdownOptionEntity>? pets,
    List<DropdownOptionEntity>? readyToLeave,
    List<ParentDropdownEntity>? bodyType,
    List<DropdownOptionEntity>? vehicles,
    List<DropdownOptionEntity>? emissionStandards,
    List<DropdownOptionEntity>? fuelType,
    List<DropdownOptionEntity>? make,
    List<DropdownOptionEntity>? mileageUnit,
    List<DropdownOptionEntity>? transmission,
    List<DropdownOptionEntity>? energyRating,
    List<DropdownOptionEntity>? propertyType,
  }) {
    return CategoriesEntity(
      items: items ?? this.items,
      clothesSizes: clothesSizes ?? this.clothesSizes,
      footSizes: footSizes ?? this.footSizes,
      clothes: clothes ?? this.clothes,
      foot: foot ?? this.foot,
      food: food ?? this.food,
      drink: drink ?? this.drink,
      clothesBrands: clothesBrands ?? this.clothesBrands,
      footwearBrands: footwearBrands ?? this.footwearBrands,
      age: age ?? this.age,
      breed: breed ?? this.breed,
      pets: pets ?? this.pets,
      readyToLeave: readyToLeave ?? this.readyToLeave,
      bodyType: bodyType ?? this.bodyType,
      vehicles: vehicles ?? this.vehicles,
      emissionStandards: emissionStandards ?? this.emissionStandards,
      fuelType: fuelType ?? this.fuelType,
      make: make ?? this.make,
      mileageUnit: mileageUnit ?? this.mileageUnit,
      transmission: transmission ?? this.transmission,
      energyRating: energyRating ?? this.energyRating,
      propertyType: propertyType ?? this.propertyType,
    );
  }
}
