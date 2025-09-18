import '../../../../domain/entities/category_entites/subentities/dropdown_option_data_entity.dart';

class DropdownOptionDataModel extends DropdownOptionDataEntity {
  /// Optional: direct JSON helpers
  factory DropdownOptionDataModel.fromJson(Map<String, dynamic> json) =>
      DropdownOptionDataModel.fromMap(json);
  DropdownOptionDataModel({
    required super.label,
    required super.value,
    super.no, // optional
  });

  /// Factory from entity
  factory DropdownOptionDataModel.fromEntity(DropdownOptionDataEntity entity) {
    return DropdownOptionDataModel(
      label: entity.label,
      value: entity.value,
      no: entity.no,
    );
  }

  /// Factory from Map / JSON
  factory DropdownOptionDataModel.fromMap(Map<String, dynamic> map) {
    return DropdownOptionDataModel(
      label: map['label'] ?? '',
      value: map['value'] ?? '',
      no: map['no'], // can be null
    );
  }

  /// Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'value': value,
      'no': no,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  /// Optional: copyWith
  DropdownOptionDataModel copyWith({
    String? label,
    String? value,
    String? no,
  }) {
    return DropdownOptionDataModel(
      label: label ?? this.label,
      value: value ?? this.value,
      no: no ?? this.no,
    );
  }

  /// Business logic helpers
  bool get hasNumber => no != null && no!.isNotEmpty;

  String get displayText {
    if (hasNumber) {
      return '$label ($no)';
    }
    return label;
  }

  /// Compare sizes for sorting
  int compareTo(DropdownOptionDataEntity other) {
    return value.compareTo(other.value);
  }

  static DropdownOptionDataEntity? findByValue(
    List<DropdownOptionDataEntity> list,
    String valueToFind,
  ) {
    try {
      return list.firstWhere(
        (opt) => opt.value == valueToFind,
      );
    } catch (_) {
      return null; // not found
    }
  }

  @override
  String toString() =>
      'DropdownOptionDataModel(label: $label, value: $value, no: $no)';
}
