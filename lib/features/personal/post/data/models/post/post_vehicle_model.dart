import '../../../../listing/listing_form/data/sources/local/local_colors.dart';
import '../../../domain/entities/post/post_vehicle_entity.dart';

class PostVehicleModel extends PostVehicleEntity {
  PostVehicleModel({
    required super.year,
    required super.doors,
    required super.seats,
    required super.mileage,
    required super.make,
    required super.model,
    required super.bodyType,
    required super.emission,
    required super.fuelType,
    required super.engineSize,
    required super.mileageUnit,
    required super.transmission,
    required super.interiorColor,
    required super.exteriorColor,
    required super.vehiclesCategory,
    required super.address,
  });

  factory PostVehicleModel.fromJson(Map<String, dynamic> json) {
    return PostVehicleModel(
      year: json['year'] ?? 0000,
      doors: json['doors'] ?? 0,
      seats: json['seats'] ?? 0,
      mileage: json['mileage'] ?? 0,
      make: json['make']?.toString(),
      model: json['model']?.toString(),
      bodyType: json['body_type']?.toString(),
      emission: json['emission']?.toString(),
      fuelType: json['fuel_type']?.toString(),
      engineSize:
          double.tryParse(json['engine_size']?.toString() ?? '0.0') ?? 0.0,
      mileageUnit: json['mileage_unit']?.toString(),
      transmission: json['transmission']?.toString(),
      interiorColor: LocalColors().getColor(
        json['interior_color']?.toString() ?? '',
      ),
      exteriorColor: LocalColors().getColor(
        json['exterior_color']?.toString() ?? '',
      ),
      vehiclesCategory: json['vehicles_category']?.toString(),
      address: json['address']?.toString() ?? '',
    );
  }

  // Map representation for request params (values as strings)
  Map<String, String> toParamMap() => <String, String>{
    'make': make ?? '',
    'model': model ?? '',
    'body_type': bodyType ?? '',
    'emission': emission ?? '',
    'fuel_type': fuelType ?? '',
    'engine_size': engineSize.toString(),
    'mileage_unit': mileageUnit ?? '',
    'transmission': transmission ?? '',
    'interior_color': interiorColor?.value ?? '',
    'exterior_color': exteriorColor?.value ?? '',
    'vehicles_category': vehiclesCategory ?? '',
    'year': year?.toString() ?? '',
    'doors': doors?.toString() ?? '',
    'seats': seats?.toString() ?? '',
    'mileage': mileage?.toString() ?? '',
    'address': address,
  };
}
