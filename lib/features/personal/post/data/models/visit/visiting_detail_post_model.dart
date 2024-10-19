import '../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../../core/extension/string_ext.dart';
import '../../../../../attachment/data/attchment_model.dart';
import '../../../../location/data/models/location_model.dart';
import '../../../domain/entities/visit/visiting_detail_post_entity.dart';
import '../meetup/availability_model.dart';

class VisitingDetailPostModel extends VisitingDetailPostEntity {
  VisitingDetailPostModel({
    required super.listId,
    required super.currentLongitude,
    required super.year,
    required super.vehiclesCategory,
    required super.createdAt,
    required super.description,
    required super.availability,
    required super.fileUrls,
    required super.title,
    required super.acceptOffers,
    required super.seats,
    required super.emission,
    required super.transmission,
    required super.price,
    required super.condition,
    required super.bodyType,
    required super.currency,
    required super.model,
    required super.privacy,
    required super.make,
    required super.mileage,
    required super.address,
    required super.isActive,
    required super.interiorColor,
    required super.createdBy,
    required super.doors,
    required super.currentLatitude,
    required super.mileageUnit,
    required super.postId,
    required super.exteriorColor,
    required super.meetUpLocation,
    required super.engineSize,
    super.fuelType,
    super.accessCode,
  });

  factory VisitingDetailPostModel.fromJson(Map<String, dynamic> json) =>
      VisitingDetailPostModel(
        listId: json['list_id'],
        currentLongitude: json['current_longitude']?.toDouble(),
        year: json['year'],
        vehiclesCategory: json['vehicles_category'],
        createdAt: (json['created_at']?.toString() ?? '').toDateTime() ??
            DateTime.now(),
        description: json['description'],
        availability: List<AvailabilityModel>.from(
            (json['availability'] ?? <dynamic>[])
                .map((dynamic x) => AvailabilityModel.fromJson(x))),
        fileUrls: List<AttachmentModel>.from((json['file_urls'] ?? <dynamic>[])
            .map((dynamic x) => AttachmentModel.fromJson(x))),
        title: json['title'],
        acceptOffers: json['accept_offers'],
        seats: json['seats'],
        emission: json['emission'],
        transmission: json['transmission'],
        price: json['price'],
        condition: ConditionType.fromJson(json['item_condition']),
        bodyType: json['body_type'],
        currency: json['currency'],
        model: json['model'],
        privacy: PrivacyType.fromJson(json['post_privacy']),
        fuelType: json['fuel_type'],
        make: json['make'],
        mileage: json['mileage'],
        address: json['address'],
        isActive: json['is_active'],
        interiorColor: json['interior_color'],
        createdBy: json['created_by'],
        doors: json['doors'],
        currentLatitude: json['current_latitude']?.toDouble(),
        mileageUnit: json['mileage_unit'],
        postId: json['post_id'],
        exteriorColor: json['exterior_color'],
        meetUpLocation: LocationModel.fromJson(json['meet_up_location']),
        engineSize: json['engine_size']?.toDouble(),
        accessCode: json['access_code'],
      );
}
