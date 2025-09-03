import 'package:hive/hive.dart';
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
  final String? interiorColor;
  @HiveField(13)
  final String? exteriorColor;
  @HiveField(14)
  final String? vehiclesCategory;
}
