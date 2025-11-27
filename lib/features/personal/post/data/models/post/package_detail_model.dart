import 'dart:convert';
import '../../../domain/entities/post/package_detail_entity.dart';

class PackageDetailModel extends PackageDetailEntity {
  factory PackageDetailModel.fromEntity(PackageDetailEntity entity) {
    return PackageDetailModel(
      length: entity.length,
      width: entity.width,
      weight: entity.weight,
      height: entity.height,
    );
  }

  factory PackageDetailModel.fromJson(Map<String, dynamic> json) {
    return PackageDetailModel(
      length: _toDouble(json['length']),
      width: _toDouble(json['width']),
      weight: _toDouble(json['weight']),
      height: _toDouble(json['height']),
    );
  }
  PackageDetailModel({
    required super.length,
    required super.width,
    required super.weight,
    required super.height,
  });

  // SAFE HELPER to convert any type → double
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;

    if (value is double) return value;
    if (value is int) return value.toDouble();

    if (value is String) return double.tryParse(value) ?? 0.0;

    return 0.0;
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'length': length,
        'width': width,
        'weight': weight,
        'height': height,
      };

  String toJson() => jsonEncode(toMap());

  PackageDetailEntity toEntity() => PackageDetailEntity(
        length: length,
        width: width,
        weight: weight,
        height: height,
      );

  static PackageDetailModel get empty => PackageDetailModel(
        length: 0.0,
        width: 0.0,
        weight: 0.0,
        height: 0.0,
      );

  bool get isEmpty =>
      length == 0.0 && width == 0.0 && weight == 0.0 && height == 0.0;

  bool get isNotEmpty => !isEmpty;
}
