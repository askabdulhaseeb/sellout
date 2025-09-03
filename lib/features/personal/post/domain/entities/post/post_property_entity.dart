import 'package:hive/hive.dart';
part 'post_property_entity.g.dart';

@HiveType(typeId: 71)
class PostPropertyEntity {
  PostPropertyEntity({
    this.bedroom,
    this.bathroom,
    this.energyRating,
    this.propertyType,
    this.propertyCategory,
    this.garden,
    this.parking,
    this.tenureType,
  });

  @HiveField(0)
  final int? bedroom;

  @HiveField(1)
  final int? bathroom;

  @HiveField(2)
  final String? energyRating;

  @HiveField(3)
  final String? propertyType;

  @HiveField(4)
  final String? propertyCategory;

  @HiveField(5)
  final bool? garden;

  @HiveField(6)
  final bool? parking;

  @HiveField(7)
  final String? tenureType;
}
