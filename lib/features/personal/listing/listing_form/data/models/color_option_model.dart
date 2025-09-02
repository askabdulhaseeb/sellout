import 'dart:convert';
import '../../domain/entities/color_options_entity.dart';

class ColorOptionModel extends ColorOptionEntity {
  factory ColorOptionModel.fromEntity(ColorOptionEntity entity) {
    return ColorOptionModel(
      label: entity.label,
      value: entity.value,
      shade: entity.shade,
      tag: entity.tag,
    );
  }
  ColorOptionModel({
    required super.label,
    required super.value,
    required super.shade,
    required super.tag,
  });

  /// Create from individual color json object
  factory ColorOptionModel.fromJson(Map<String, dynamic> json) {
    return ColorOptionModel(
      label: json['label'] ?? '',
      value: json['value'] ?? '',
      shade: json['shade'] ?? '',
      tag: (json['tag'] as List<dynamic>)
          .map((dynamic e) => e.toString())
          .toList(),
    );
  }

  /// Parse the outer colors map -> list of models
  static List<ColorOptionModel> listFromApi(Map<String, dynamic> apiMap) {
    final Map<String, dynamic> colorsMap =
        apiMap['colors'] ?? <String, dynamic>{};
    return colorsMap.entries.map((MapEntry<String, dynamic> entry) {
      // You can also double-check that entry.key matches value['value']
      return ColorOptionModel.fromJson(entry.value);
    }).toList();
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
