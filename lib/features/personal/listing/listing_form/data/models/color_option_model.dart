import 'dart:convert';
import '../../domain/entities/color_options_entity.dart';

class ColorOptionModel extends ColorOptionEntity {
  ColorOptionModel({
    required super.label,
    required super.value,
    required super.shade,
    required super.tag,
  });

  // Factory constructor to create an instance from JSON
  factory ColorOptionModel.fromJson(Map<String, dynamic> json) {
    return ColorOptionModel(
      label: json['label'],
      value: json['value'],
      shade: json['shade'],
      tag: List<String>.from(json['tag']),
    );
  }

  factory ColorOptionModel.fromEntity(ColorOptionEntity entity) {
    return ColorOptionModel(
        label: entity.label,
        value: entity.value,
        shade: entity.shade,
        tag: entity.tag);
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'label': label,
      'value': value,
      'shade': shade,
      'tag': tag,
    };
  }

  String toJson() => json.encode(toMap());
}
