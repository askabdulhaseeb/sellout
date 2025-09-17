import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../domain/entities/category_entites/categories_entity.dart';
import '../../../domain/entities/category_entites/subentities/dropdown_option_data_entity.dart';
import '../../../domain/entities/category_entites/subentities/dropdown_option_entity.dart';

class LocalCategoriesSource {
  static String boxTitle = AppStrings.localDropDownListingBox;
  static const String _mainKey = 'categories';

  Future<Box<CategoriesEntity>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    if (isOpen) {
      return _box;
    } else {
      return await Hive.openBox<CategoriesEntity>(boxTitle);
    }
  }

  static Future<Box<CategoriesEntity>> openBox() async {
    return await Hive.openBox<CategoriesEntity>(boxTitle);
  }

  static Box<CategoriesEntity> get _box => Hive.box<CategoriesEntity>(boxTitle);

  Future<void> save(CategoriesEntity value) async {
    await _box.put(_mainKey, value);
  }

  /// Always read from the main key
  static CategoriesEntity? get categories =>
      _box.isEmpty ? null : _box.get(_mainKey);

  Future<void> saveNonNullFields(CategoriesEntity newEntity) async {
    final CategoriesEntity? existing = _box.get(_mainKey);
    if (existing == null) {
      await save(newEntity);
      return;
    }
    debugPrint('catgeories saving start');
    final CategoriesEntity merged = existing.copyWith(
      clothesSizes: newEntity.clothesSizes ?? existing.clothesSizes,
      footSizes: newEntity.footSizes ?? existing.footSizes,
      clothesBrands: newEntity.clothesBrands ?? existing.clothesBrands,
      footwearBrands: newEntity.footwearBrands ?? existing.footwearBrands,
      age: newEntity.age ?? existing.age,
      breed: newEntity.breed ?? existing.breed,
      pets: newEntity.pets ?? existing.pets,
      readyToLeave: newEntity.readyToLeave ?? existing.readyToLeave,
      vehicles: newEntity.vehicles ?? existing.vehicles,
      emissionStandards:
          newEntity.emissionStandards ?? existing.emissionStandards,
      fuelType: newEntity.fuelType ?? existing.fuelType,
      make: newEntity.make ?? existing.make,
      mileageUnit: newEntity.mileageUnit ?? existing.mileageUnit,
      transmission: newEntity.transmission ?? existing.transmission,
      energyRating: newEntity.energyRating ?? existing.energyRating,
      propertyType: newEntity.propertyType ?? existing.propertyType,
    );

    await save(merged);
  }

  static List<DropdownOptionEntity>? get clothesSizes =>
      categories?.clothesSizes;

  static List<DropdownOptionEntity>? get footSizes => categories?.footSizes;

  static List<DropdownOptionDataEntity>? get clothesBrands =>
      categories?.clothesBrands;

  static List<DropdownOptionDataEntity>? get footwearBrands =>
      categories?.footwearBrands;

  static List<DropdownOptionEntity>? get age => categories?.age;

  static List<DropdownOptionEntity>? get breed => categories?.breed;

  static List<DropdownOptionEntity>? get pets => categories?.pets;

  static List<DropdownOptionEntity>? get readyToLeave =>
      categories?.readyToLeave;

  static List<DropdownOptionEntity>? get vehicles => categories?.vehicles;

  static List<DropdownOptionEntity>? get emissionStandards =>
      categories?.emissionStandards;

  static List<DropdownOptionEntity>? get fuelType => categories?.fuelType;

  static List<DropdownOptionEntity>? get make => categories?.make;

  static List<DropdownOptionEntity>? get mileageUnit => categories?.mileageUnit;

  static List<DropdownOptionEntity>? get transmission =>
      categories?.transmission;
  static List<DropdownOptionEntity>? get energyRating =>
      categories?.energyRating;

  static List<DropdownOptionEntity>? get propertyType =>
      categories?.propertyType;

  CategoriesEntity? getCategory() => _box.get(_mainKey);

  Future<void> updateCategory(CategoriesEntity newEntity) async {
    await save(newEntity);
  }

  Future<void> clear() async => await _box.clear();
}
