import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../../../domain/entities/category_entites/categories_entity.dart';
import 'sub_models/parent_dropdown_model.dart';
import 'sub_models/dropdown_option.model.dart';
import '../sub_category_model.dart';
import 'package:flutter/foundation.dart';
import 'sub_models/dropdown_option_data_model.dart';

class CategoriesModel extends CategoriesEntity {
  factory CategoriesModel.fromJson(String jsonString) {
    final decoded = jsonDecode(jsonString);

    // Merge all maps if wrapped inside a list
    final Map<String, dynamic> mergedJson = <String, dynamic>{};
    if (decoded is List) {
      for (final element in decoded) {
        if (element is Map<String, dynamic>) mergedJson.addAll(element);
      }
    } else if (decoded is Map<String, dynamic>) {
      mergedJson.addAll(decoded);
    }

    final List<String> populatedFields = <String>[];

    // --- Helper parsers ---
    List<DropdownOptionModel>? parseMap(dynamic value) {
      if (value == null) return null;
      if (value is Map<String, dynamic>) {
        return value.values
            .whereType<Map<String, dynamic>>()
            .map(DropdownOptionModel.fromJson)
            .toList();
      }
      return null;
    }

    DropdownOptionDataModel parseDataOption(dynamic e) {
      if (e is Map<String, dynamic>) return DropdownOptionDataModel.fromJson(e);
      if (e is String) return DropdownOptionDataModel(label: e, value: e);
      throw Exception('Invalid dropdown data option: $e');
    }

    List<DropdownOptionDataModel>? parseDataList(dynamic value) {
      if (value == null) return null;
      if (value is List && value.isNotEmpty) {
        return value.map(parseDataOption).toList();
      }
      return null;
    }

    // --- Clothes ---
    final List<DropdownOptionDataModel>? clothesBrands =
        parseDataList(mergedJson['clothes_brands']);
    if (clothesBrands != null) populatedFields.add('clothesBrands');

    final List<DropdownOptionDataModel>? footwearBrands =
        parseDataList(mergedJson['footwear_brands']);
    if (footwearBrands != null) populatedFields.add('footwearBrands');

    final List<DropdownOptionModel> clothesSizes =
        parseMap(mergedJson['clothes_sizes']) ?? <DropdownOptionModel>[];
    if (clothesSizes.isNotEmpty) populatedFields.add('clothesSizes');

    final List<DropdownOptionModel> footSizes =
        parseMap(mergedJson['foot_sizes']) ?? <DropdownOptionModel>[];
    if (footSizes.isNotEmpty) populatedFields.add('footSizes');

    // --- Pets ---
    final Map<String, dynamic>? breedMap = mergedJson['breed'];
    final List<ParentDropdownModel>? breed = breedMap?.entries
        .map((MapEntry<String, dynamic> entry) => ParentDropdownModel.fromJson(
            entry.key, entry.value as Map<String, dynamic>))
        .toList();
    if (breed != null) populatedFields.add('breed');

    final List<DropdownOptionModel>? age = parseMap(mergedJson['age']);
    if (age != null) populatedFields.add('age');

    final List<DropdownOptionModel>? readyToLeave =
        parseMap(mergedJson['ready_to_leave']);
    if (readyToLeave != null) populatedFields.add('readyToLeave');

    final List<DropdownOptionModel>? pets = parseMap(mergedJson['pets']);
    if (pets != null) populatedFields.add('pets');

    // --- Vehicles ---
    final Map<String, dynamic>? bodyTypeMap = mergedJson['body_type'];
    final List<ParentDropdownModel>? bodyType = bodyTypeMap?.entries
        .map((MapEntry<String, dynamic> entry) => ParentDropdownModel.fromJson(
            entry.key, entry.value as Map<String, dynamic>))
        .toList();
    if (bodyType != null) populatedFields.add('bodyType');

    final List<DropdownOptionModel>? emissionStandards =
        parseMap(mergedJson['emission_standards']);
    if (emissionStandards != null) populatedFields.add('emissionStandards');

    final List<DropdownOptionModel>? fuelType =
        parseMap(mergedJson['fuel_type']);
    if (fuelType != null) populatedFields.add('fuelType');

    final List<DropdownOptionModel>? make = parseMap(mergedJson['make']);
    if (make != null) populatedFields.add('make');

    final List<DropdownOptionModel>? mileageUnit =
        parseMap(mergedJson['mileage_unit']);
    if (mileageUnit != null) populatedFields.add('mileageUnit');

    final List<DropdownOptionModel>? transmission =
        parseMap(mergedJson['transmission']);
    if (transmission != null) populatedFields.add('transmission');

    final List<DropdownOptionModel>? vehicles =
        parseMap(mergedJson['vehicles']);
    if (vehicles != null) populatedFields.add('vehicles');

    final List<DropdownOptionModel>? energyRating =
        parseMap(mergedJson['energy_rating']);
    if (energyRating != null) populatedFields.add('energyRating');

    final List<DropdownOptionModel>? propertyType =
        parseMap(mergedJson['property_type']);
    if (propertyType != null) populatedFields.add('propertyType');

    // --- Items ---
    final SubCategoryModel? items = mergedJson['items'] != null
        ? SubCategoryModel.fromJson(mergedJson['items'])
        : null;
    if (items != null) populatedFields.add('items');

    // --- Food ---
    final SubCategoryModel? food = mergedJson['food'] != null
        ? SubCategoryModel.fromJson(mergedJson['food'])
        : null;
    if (food != null) populatedFields.add('food');
    // --- Drink ---
    final SubCategoryModel? drink = mergedJson['drink'] != null
        ? SubCategoryModel.fromJson(mergedJson['drink'])
        : null;
    if (drink != null) populatedFields.add('drink');
    // --- Clothes & Foot ---
    final SubCategoryModel? clothes = mergedJson['clothes'] != null
        ? SubCategoryModel.fromJson(mergedJson['clothes'])
        : null;
    if (clothes != null) populatedFields.add('clothes');

    final SubCategoryModel? foot = mergedJson['foot'] != null
        ? SubCategoryModel.fromJson(mergedJson['foot'])
        : null;
    if (foot != null) populatedFields.add('foot');

    debugPrint(
        '✅ CategoriesModel.fromJson - Populated fields: $populatedFields');

    return CategoriesModel(
      clothesBrands: clothesBrands,
      footwearBrands: footwearBrands,
      clothesSizes: clothesSizes,
      footSizes: footSizes,
      age: age,
      bodyType: bodyType,
      breed: breed,
      pets: pets,
      readyToLeave: readyToLeave,
      emissionStandards: emissionStandards,
      fuelType: fuelType,
      make: make,
      mileageUnit: mileageUnit,
      transmission: transmission,
      vehicles: vehicles,
      energyRating: energyRating,
      propertyType: propertyType,
      items: items,
      clothes: clothes,
      foot: foot,
      food: food,
      drink: drink,
    );
  }

  CategoriesModel({
    super.clothesBrands,
    super.footwearBrands,
    super.clothesSizes,
    super.footSizes,
    super.age,
    super.breed,
    super.pets,
    super.readyToLeave,
    super.bodyType,
    super.emissionStandards,
    super.fuelType,
    super.make,
    super.mileageUnit,
    super.transmission,
    super.vehicles,
    super.energyRating,
    super.propertyType,
    super.items,
    super.clothes,
    super.foot,
    super.food,
    super.drink,
  });
}
