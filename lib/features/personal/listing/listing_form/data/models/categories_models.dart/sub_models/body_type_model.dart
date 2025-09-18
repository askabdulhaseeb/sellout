import '../../../../domain/entities/category_entites/subentities/body_type_entity.dart';
import 'dropdown_option.model.dart';

class BodyTypeModel extends BodyTypeEntity {
  BodyTypeModel({
    required super.category,
    required super.options,
  });

  /// Factory from JSON — Data layer handles parsing
  factory BodyTypeModel.fromJson(String category, Map<String, dynamic> map) {
    final options = map.values.map((v) {
      return DropdownOptionModel.fromJson(v as Map<String, dynamic>);
    }).toList();

    return BodyTypeModel(
      category: category,
      options: options,
    );
  }

  /// Convert back to JSON
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'options': options.map((o) {
        if (o is DropdownOptionModel) return o.toJson();
        // fallback if just DropdownOptionEntity
        return {
          'label': o.label,
          'value': o.value,
        };
      }).toList(),
    };
  }
}
