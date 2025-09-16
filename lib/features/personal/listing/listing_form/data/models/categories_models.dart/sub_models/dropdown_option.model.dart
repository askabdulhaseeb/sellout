// dropdown_option_model.dart
import '../../../../domain/entities/category_entites/subentities/dropdown_option_entity.dart';

class DropdownOptionModel extends DropdownOptionEntity {
  DropdownOptionModel({
    required super.label,
    required super.value,
  });

  // From entity
  factory DropdownOptionModel.fromEntity(DropdownOptionEntity entity) {
    return DropdownOptionModel(
      label: entity.label,
      value: entity.value,
    );
  }

  // From JSON / Map
  factory DropdownOptionModel.fromJson(Map<String, dynamic> map) {
    return DropdownOptionModel(
      label: map['label'] ?? '',
      value: map['value'] ?? '',
    );
  }

  // To Map
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
    };
  }

  // // Extra UI helper
  // String get capitalizedLabel {
  //   if (label.isEmpty) return label;
  //   return label[0].toUpperCase() + label.substring(1);
  // }
}
