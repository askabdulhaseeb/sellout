import '../../../domain/entities/category_entites/categories_entity.dart';
import '../../../domain/entities/category_entites/subentities/dropdown_option_entity.dart';
import '../../../domain/entities/category_entites/subentities/dropdown_option_data_entity.dart';
import 'sub_models/dropdown_option.model.dart';
import 'sub_models/dropdown_option_data_model.dart';
import '../sub_category_model.dart';

class CategoriesModel extends CategoriesEntity {
  CategoriesModel({
    super.items,
    super.clothesSizes,
    super.footSizes,
    super.clothes,
    super.foot,
    super.clothesBrands,
    super.footwearBrands,
    super.age,
    super.breed,
    super.pets,
    super.readyToLeave,
  });

  /// ---------- FROM JSON ----------
  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      clothesBrands: (json['clothes_brands'] ?? <dynamic>[])
          ?.map((dynamic e) => DropdownOptionDataModel.fromJson(e))
          .toList(),
      footwearBrands: (json['footwear_brands'] ?? <dynamic>[])
          ?.map((dynamic e) => DropdownOptionDataModel.fromJson(e))
          .toList(),
      clothesSizes: (json['clothes_sizes'] ?? <dynamic>[])
          ?.map((dynamic e) => DropdownOptionModel.fromJson(e))
          .toList(),
      footSizes: (json['foot_sizes'] ?? <dynamic>[])
          ?.map((dynamic e) => DropdownOptionModel.fromJson(e))
          .toList(),
      age: (json['age'] ?? <dynamic>[])
          ?.map((dynamic e) => DropdownOptionModel.fromJson(e))
          .toList(),
      breed: (json['breed'] ?? <dynamic>[])
          ?.map((dynamic e) => DropdownOptionModel.fromJson(e))
          .toList(),
      pets: (json['pets'] ?? <dynamic>[])
          ?.map((dynamic e) => DropdownOptionModel.fromJson(e))
          .toList(),
      readyToLeave: (json['ready_to_leave'] ?? <dynamic>[])
          ?.map((dynamic e) => DropdownOptionModel.fromJson(e))
          .toList(),
      items: json['items'] != null
          ? SubCategoryModel.fromJson(json['items'])
          : null,
      clothes: json['clothes'] != null
          ? SubCategoryModel.fromJson(json['clothes'])
          : null,
      foot:
          json['foot'] != null ? SubCategoryModel.fromJson(json['foot']) : null,
    );
  }

  /// ---------- TO JSON ----------
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'clothes_brands': clothesBrands
          ?.map((DropdownOptionEntity e) => (e as DropdownOptionModel).toJson())
          .toList(),
      'footwear_brands': footwearBrands
          ?.map((DropdownOptionEntity e) => (e as DropdownOptionModel).toJson())
          .toList(),
      'clothes_sizes': clothesSizes
          ?.map((DropdownOptionDataEntity e) =>
              (e as DropdownOptionDataModel).toMap())
          .toList(),
      'foot_sizes': footSizes
          ?.map((DropdownOptionDataEntity e) =>
              (e as DropdownOptionDataModel).toMap())
          .toList(),
      'age': age
          ?.map((DropdownOptionDataEntity e) =>
              (e as DropdownOptionDataModel).toMap())
          .toList(),
      'breed': breed
          ?.map((DropdownOptionDataEntity e) =>
              (e as DropdownOptionDataModel).toMap())
          .toList(),
      'pets': pets
          ?.map((DropdownOptionDataEntity e) =>
              (e as DropdownOptionDataModel).toMap())
          .toList(),
      'ready_to_leave': readyToLeave
          ?.map((DropdownOptionDataEntity e) =>
              (e as DropdownOptionDataModel).toMap())
          .toList(),
      'items': items,
      'clothes': clothes,
      'foot': foot,
    };
  }
}
