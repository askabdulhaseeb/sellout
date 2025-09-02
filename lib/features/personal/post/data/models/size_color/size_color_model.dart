import '../../../domain/entities/size_color/color_entity.dart';
import '../../../domain/entities/size_color/size_color_entity.dart';
import 'color_model.dart';

class SizeColorModel extends SizeColorEntity {
  SizeColorModel({
    required super.value,
    required super.colors,
    required super.id,
  });

  factory SizeColorModel.fromJson(Map<String, dynamic> json) => SizeColorModel(
        value: json['value'],
        colors: List<ColorModel>.from(
          (json['colors'] ?? <dynamic>[]).map(
            (dynamic x) => ColorModel.fromJson(x),
          ),
        ),
        id: json['id'],
      );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'value': value.toLowerCase(),
      'colors': colors
          .map((ColorEntity x) => ColorModel.fromEntity(x).toMap())
          .toList(),
      'id': id.toLowerCase(),
    };
  }
}
