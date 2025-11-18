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

  /// Parse from JSON with formatting
  factory PackageDetailModel.fromJson(Map<String, dynamic> json) {
    return PackageDetailModel(
      length: _formatValue(json['length']),
      width: _formatValue(json['width']),
      weight: _formatValue(json['weight']),
      height: _formatValue(json['height']),
    );
  }

  /// Convert dynamic value to formatted string
  static String _formatValue(dynamic value) {
    double number;
    if (value == null) return '0';
    if (value is int) number = value.toDouble();
    else if (value is double) number = value;
    else if (value is String) number = double.tryParse(value) ?? 0.0;
    else number = 0.0;

    // Round to 1 decimal
    number = (number * 10).round() / 10;
    // Remove .0 if integer
    if (number == number.toInt()) return number.toInt().toString();
    return number.toStringAsFixed(1);
  }

  /// Map representation (Object → Map)
  Map<String, dynamic> toMap() => <String, dynamic>{
        'length': length,
        'width': width,
        'weight': weight,
        'height': height,
      };

  /// JSON string representation
  String toJson() => jsonEncode(toMap());

  /// Convert back to entity
  PackageDetailEntity toEntity() => PackageDetailEntity(
        length: length,
        width: width,
        weight: weight,
        height: height,
      );

  // Empty package detail
  static PackageDetailModel get empty => PackageDetailModel(
        length: '0',
        width: '0',
        weight: '0',
        height: '0',
      );

  bool get isEmpty =>
      length == '0' && width == '0' && weight == '0' && height == '0';
  bool get isNotEmpty => !isEmpty;
}
