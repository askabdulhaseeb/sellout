// dropdown_option_model.dart
import '../../../../domain/entities/category_entites/subentities/dropdown_option_entity.dart';
import 'dropdown_option_data_model.dart';

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
      label: map['label']?.toString() ?? '',
      value: DropdownOptionDataModel(
        label: map['label']?.toString() ?? '',
        value: map['value']?.toString() ?? '',
      ),
    );
  }

  // To Map
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'label': label,
      'value': <String, String>{
        'label': value.label,
        'value': value.value,
      },
    };
  }
}
