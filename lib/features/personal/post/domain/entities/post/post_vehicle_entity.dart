import 'package:hive_ce/hive.dart';

import '../../../../listing/listing_form/domain/entities/color_options_entity.dart';
part 'post_vehicle_entity.g.dart';

@HiveType(typeId: 69)
class PostVehicleEntity {
  PostVehicleEntity({
    required this.year,
    required this.doors,
    required this.seats,
    required this.mileage,
    required this.make,
    required this.model,
    required this.bodyType,
    required this.emission,
    required this.fuelType,
    required this.engineSize,
    required this.mileageUnit,
    required this.transmission,
    required this.interiorColor,
    required this.exteriorColor,
    required this.vehiclesCategory,
    required this.address,
  });
  @HiveField(0)
  final int? year;
  @HiveField(1)
  final int? doors;
  @HiveField(2)
  final int? seats;
  @HiveField(3)
  final int? mileage;
  @HiveField(4)
  final String? make;
  @HiveField(5)
  final String? model;
  @HiveField(6)
  final String? bodyType;
  @HiveField(7)
  final String? emission;
  @HiveField(8)
  final String? fuelType;
  @HiveField(9)
  final double? engineSize;
  @HiveField(10)
  final String? mileageUnit;
  @HiveField(11)
  final String? transmission;
  @HiveField(12)
  final ColorOptionEntity? interiorColor;
  @HiveField(13)
  final ColorOptionEntity? exteriorColor;
  @HiveField(14)
  final String? vehiclesCategory;
  @HiveField(15)
  final String address;
}
