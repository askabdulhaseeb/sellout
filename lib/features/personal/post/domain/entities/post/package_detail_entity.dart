import 'package:hive_ce/hive.dart';
part 'package_detail_entity.g.dart';

@HiveType(typeId: 75)
class PackageDetailEntity {
  PackageDetailEntity({
    required this.length,
    required this.width,
    required this.weight,
    required this.height,
  });
  @HiveField(0)
  final double length;

  @HiveField(1)
  final double width;

  @HiveField(2)
  final double weight;

  @HiveField(3)
  final double height;

  // Copy with method for easy updates
  PackageDetailEntity copyWith({
    double? length,
    double? width,
    double? weight,
    double? height,
  }) {
    return PackageDetailEntity(
      length: length ?? this.length,
      width: width ?? this.width,
      weight: weight ?? this.weight,
      height: height ?? this.height,
    );
  }
}
