import 'dart:convert';
import '../../../domain/entities/post/package_detail_entity.dart';

class PackageDetailModel extends PackageDetailEntity {
  PackageDetailModel({
    required super.length,
    required super.width,
    required super.weight,
    required super.height,
  });

  /// Build a model from the domain entity
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
      length: _parseDouble(json['length']),
      width: _parseDouble(json['width']),
      weight: _parseDouble(json['weight']),
      height: _parseDouble(json['height']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Map representation (Object → Map)
  Map<String, dynamic> toMap() => <String, dynamic>{
        'length': length,
        'width': width,
        'weight': weight,
        'height': height,
      };

  /// JSON string representation (Object → JSON)
  String toJson() => jsonEncode(toMap());

  /// Convert back to the domain entity
  PackageDetailEntity toEntity() => PackageDetailEntity(
        length: length,
        width: width,
        weight: weight,
        height: height,
      );

  // Empty package detail
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
