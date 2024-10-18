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
        id: json['id'],
        value: json['value'],
        colors: List<ColorModel>.from((json['colors'] ?? <dynamic>[])
            .map((dynamic x) => ColorModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'value': value,
        'colors': List<dynamic>.from(
            colors.map((ColorEntity x) => ColorModel.fromEntity(x).toJson())),
      };
}
