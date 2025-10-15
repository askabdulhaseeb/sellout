import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import '../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../domain/entities/category_entites/categories_entity.dart';
import '../../../domain/entities/category_entites/subentities/dropdown_option_data_entity.dart';
import '../../../domain/entities/category_entites/subentities/dropdown_option_entity.dart';
import '../../../domain/entities/category_entites/subentities/parent_dropdown_entity.dart';
import '../../../domain/entities/sub_category_entity.dart';

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
      if (newValue is List && newValue.isEmpty) return oldValue;
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
      items: keepOldIfNullOrEmpty(newEntity.items, existing.items),
      clothes: keepOldIfNullOrEmpty(newEntity.clothes, existing.clothes),
      foot: keepOldIfNullOrEmpty(newEntity.foot, existing.foot),
      food: keepOldIfNullOrEmpty(newEntity.food, existing.food),
      drink: keepOldIfNullOrEmpty(newEntity.drink, existing.drink),
    );

    await save(merged);
  }

  // ===== Getters for easy access =====

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

  // ===== Subcategories =====
  static SubCategoryEntity? get items => categories?.items;
  static SubCategoryEntity? get clothes => categories?.clothes;
  static SubCategoryEntity? get foot => categories?.foot;
  static SubCategoryEntity? get food => categories?.food;
  static SubCategoryEntity? get drink => categories?.drink;
  CategoriesEntity? getCategory() => _box.get(_mainKey);

//Find a subcategory based on address example "listingtype/cid/subcat/subcat"
//Find an item subcategory based on address example "listingtype/subcat/subcat"
  SubCategoryEntity? findSubCategoryByAddress(String address) {
    try {
      debugPrint('🔍 FINDING SUBCATEGORY FOR ADDRESS: "$address"');

      if (address.isEmpty) {
        debugPrint('❌ Address is empty');
        return null;
      }

      final List<String> parts = address.split('/');
      debugPrint('📝 Split address parts: $parts');

      if (parts.isEmpty) {
        debugPrint('❌ No parts found after splitting');
        return null;
      }

      final ListingType listingType;
      try {
        listingType = ListingType.fromJson(parts.first);
        debugPrint('🏷️ Listing type: $listingType');
      } catch (e) {
        debugPrint('❌ Invalid listing type: ${parts.first}');
        return null;
      }

      SubCategoryEntity? root;
      switch (listingType) {
        case ListingType.items:
          root = categories?.items;
          debugPrint('📦 Items root: ${root != null ? "FOUND" : "NOT FOUND"}');
          break;
        case ListingType.clothAndFoot:
          root = categories?.clothes;
          debugPrint(
              '👕 Clothes root: ${root != null ? "FOUND" : "NOT FOUND"}');
          break;
        case ListingType.foodAndDrink:
          root = categories?.food;
          debugPrint('🍕 Food root: ${root != null ? "FOUND" : "NOT FOUND"}');
          break;
        case ListingType.property:
        case ListingType.vehicle:
        case ListingType.pets:
          debugPrint('⏭️ Skipping type: $listingType');
          return null;
      }

      if (root == null) {
        debugPrint('❌ Root category not found');
        return null;
      }

      debugPrint('✅ Starting traversal from root: "${root.title}"');

      final List<String> partsToTraverse = parts.sublist(1);
      debugPrint('🚀 Parts to traverse: $partsToTraverse');

      SubCategoryEntity? current = root;

      for (int i = 0; i < partsToTraverse.length; i++) {
        final currentPart = partsToTraverse[i];
        debugPrint(
            '🔎 Looking for part[$i]: "$currentPart" in "${current?.title}"');

        if (current?.subCategory == []) {
          debugPrint('❌ No subcategories available in "${current?.title}"');
          break;
        }

        debugPrint('📋 Available subcategories in "${current?.title}":');
        for (final sub in current?.subCategory ?? []) {
          debugPrint(
              '   - "${sub.title}" (cid: ${sub.cid}, address: ${sub.address})');
        }

        SubCategoryEntity? foundSubCategory;

        if (listingType == ListingType.items) {
          final searchTerm = _normalizeForMatching(currentPart);
          debugPrint('🟢 ITEMS - Searching for: "$searchTerm"');

          for (final sub in current?.subCategory ?? []) {
            final subTitle = _normalizeForMatching(sub.title);
            final subAddress =
                sub.address != null ? _normalizeForMatching(sub.address!) : '';
            final subCid = _normalizeForMatching(sub.cid);

            final matches = subTitle.contains(searchTerm) ||
                searchTerm.contains(subTitle) ||
                subAddress.contains(searchTerm) ||
                subCid.contains(searchTerm) ||
                sub.cid == currentPart;

            if (matches) {
              debugPrint('   ✅ MATCH FOUND: "${sub.title}"');
              foundSubCategory = sub;
              break;
            }
          }
        } else {
          debugPrint('🟡 STANDARD - Searching for: "$currentPart"');

          for (final sub in current?.subCategory ?? []) {
            final cidMatch = sub.cid == currentPart;
            final titleMatch = _normalizeForMatching(sub.title) ==
                _normalizeForMatching(currentPart);
            final addressMatch = sub.address != null &&
                _normalizeForMatching(sub.address!) ==
                    _normalizeForMatching(currentPart);

            if (cidMatch || titleMatch || addressMatch) {
              debugPrint('   ✅ MATCH FOUND: "${sub.title}" (cid: ${sub.cid})');
              foundSubCategory = sub;
              break;
            }
          }
        }

        if (foundSubCategory != null) {
          current = foundSubCategory;
          debugPrint('➡️ Moving to: "${current.title}"');
        } else {
          debugPrint(
              '❌ No match found for "$currentPart" - stopping at "${current?.title}"');
          break;
        }
      }

      debugPrint('🎯 FINAL RESULT: "${current?.title ?? []}"');
      return current;
    } catch (e, stackTrace) {
      debugPrint('💥 ERROR in findSubCategoryByAddress: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  String _normalizeForMatching(String input) {
    return input
        .toLowerCase()
        .replaceAll('&', 'and')
        .replaceAll('-', ' ')
        .replaceAll('  ', ' ')
        .trim();
  }

  Future<void> updateCategory(CategoriesEntity newEntity) async {
    await save(newEntity);
  }

  Future<void> clear() async => await _box.clear();
}
