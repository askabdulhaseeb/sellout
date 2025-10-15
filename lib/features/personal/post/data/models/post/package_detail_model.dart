import '../../../domain/entities/post/package_detail_entity.dart';

class PackageDetailModel extends PackageDetailEntity {
  PackageDetailModel({
    required super.length,
    required super.width,
    required super.weight,
    required super.height,
  });

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

  Map<String, dynamic> toJson() {
    return {
      'length': length,
      'width': width,
      'weight': weight,
      'height': height,
    };
  }

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
