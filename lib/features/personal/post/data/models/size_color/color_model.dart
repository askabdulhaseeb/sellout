import '../../../domain/entities/size_color/color_entity.dart';

class ColorModel extends ColorEntity {
  const ColorModel({required super.code, required super.quantity});

  factory ColorModel.fromJson(Map<String, dynamic> json) => ColorModel(
        code: json['code'],
        quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      );

  factory ColorModel.fromEntity(ColorEntity entity) => ColorModel(
        code: entity.code,
        quantity: entity.quantity,
      );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'quantity': quantity,
    };
  }
}
