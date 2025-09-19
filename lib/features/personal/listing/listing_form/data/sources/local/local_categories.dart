import 'package:hive/hive.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../domain/entities/category_entites/categories_entity.dart';
import '../../../domain/entities/category_entites/subentities/dropdown_option_data_entity.dart';
import '../../../domain/entities/category_entites/subentities/dropdown_option_entity.dart';
import '../../../domain/entities/category_entites/subentities/parent_dropdown_entity.dart';

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
    T? keepOldIfNullOrEmpty<T>(T? newValue, T? oldValue) {
      if (newValue == null) return oldValue;

      if (newValue is List && newValue.isEmpty) {
        return oldValue;
      }
      return newValue;
    }

    final CategoriesEntity merged = existing.copyWith(
      bodyType: keepOldIfNullOrEmpty(newEntity.bodyType, existing.bodyType),
      clothesSizes:
          keepOldIfNullOrEmpty(newEntity.clothesSizes, existing.clothesSizes),
      footSizes: keepOldIfNullOrEmpty(newEntity.footSizes, existing.footSizes),
      clothesBrands:
          keepOldIfNullOrEmpty(newEntity.clothesBrands, existing.clothesBrands),
      footwearBrands: keepOldIfNullOrEmpty(
          newEntity.footwearBrands, existing.footwearBrands),
      age: keepOldIfNullOrEmpty(newEntity.age, existing.age),
      breed: keepOldIfNullOrEmpty(newEntity.breed, existing.breed),
      pets: keepOldIfNullOrEmpty(newEntity.pets, existing.pets),
      readyToLeave:
          keepOldIfNullOrEmpty(newEntity.readyToLeave, existing.readyToLeave),
      vehicles: keepOldIfNullOrEmpty(newEntity.vehicles, existing.vehicles),
      emissionStandards: keepOldIfNullOrEmpty(
          newEntity.emissionStandards, existing.emissionStandards),
      fuelType: keepOldIfNullOrEmpty(newEntity.fuelType, existing.fuelType),
      make: keepOldIfNullOrEmpty(newEntity.make, existing.make),
      mileageUnit:
          keepOldIfNullOrEmpty(newEntity.mileageUnit, existing.mileageUnit),
      transmission:
          keepOldIfNullOrEmpty(newEntity.transmission, existing.transmission),
      energyRating:
          keepOldIfNullOrEmpty(newEntity.energyRating, existing.energyRating),
      propertyType:
          keepOldIfNullOrEmpty(newEntity.propertyType, existing.propertyType),
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

  static List<ParentDropdownEntity>? get breed => categories?.breed;

  static List<ParentDropdownEntity>? get bodyType => categories?.bodyType;

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
