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
      length: double.tryParse(json['length'].toString()) ?? 0.0,
      width: double.tryParse(json['width'].toString()) ?? 0.0,
      weight: double.tryParse(json['weight'].toString()) ?? 0.0,
      height: double.tryParse(json['height'].toString()) ?? 0.0,
    );
  }
  PackageDetailModel({
    required super.length,
    required super.width,
    required super.weight,
    required super.height,
  });

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

  static PackageDetailModel get empty =>
      PackageDetailModel(length: 0.0, width: 0.0, weight: 0.0, height: 0.0);

  bool get isEmpty =>
      length == 0.0 && width == 0.0 && weight == 0.0 && height == 0.0;

  bool get isNotEmpty => !isEmpty;
}
