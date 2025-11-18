import '../../../../domain/entities/category_entites/subentities/parent_dropdown_entity.dart';
import 'dropdown_option.model.dart';

class ParentDropdownModel extends ParentDropdownEntity {
  ParentDropdownModel({
    required super.category,
    required super.options,
  });

  /// Parse a single category JSON into ParentDropdownModel
  factory ParentDropdownModel.fromJson(
      String category, Map<String, dynamic> json) {
    final List<DropdownOptionModel> options = json.entries
        .map((MapEntry<String, dynamic> entry) =>
            DropdownOptionModel.fromJson(entry.value as Map<String, dynamic>))
        .toList();

    return ParentDropdownModel(category: category, options: options);
  }
}
