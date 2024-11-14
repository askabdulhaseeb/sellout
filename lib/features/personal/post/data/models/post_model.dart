import '../../../../../core/enums/listing/core/boolean_status_type.dart';
import '../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../core/extension/string_ext.dart';
import '../../../../attachment/data/attchment_model.dart';
import '../../../location/data/models/location_model.dart';
import '../../domain/entities/post_entity.dart';
import 'meetup/availability_model.dart';
import 'size_color/discount_model.dart';
import 'size_color/size_color_model.dart';

class PostModel extends PostEntity {
  PostModel({
    required super.quantity,
    required super.address,
    required super.isActive,
    required super.listId,
    required super.currentLongitude,
    required super.createdAt,
    required super.discount,
    required super.description,
    required super.fileUrls,
    required super.title,
    required super.type,
    required super.createdBy,
    required super.acceptOffers,
    required super.sizeColors,
    required super.currentLatitude,
    required super.postId,
    required super.deliveryType,
    required super.price,
    required super.minOfferAmount,
    required super.condition,
    required super.sizeChartUrl,
    required super.currency,
    required super.privacy,
    required super.brand,
    //
    required super.collectionLatitude,
    required super.collectionLongitude,
    required super.collectionLocation,
    required super.localDelivery,
    required super.internationalDelivery,
    required super.fuelType,
    required super.doors,
    required super.availability,
    required super.emission,
    required super.exteriorColor,
    required super.seats,
    required super.vehiclesCategory,
    required super.meetUpLocation,
    required super.interiorColor,
    required super.transmission,
    required super.mileage,
    required super.model,
    required super.engineSize,
    required super.make,
    required super.bodyType,
    required super.mileageUnit,
    required super.year,
    required super.petsCategory,
    required super.healthChecked,
    required super.breed,
    required super.age,
    required super.vaccinationUpToDate,
    required super.readyToLeave,
    required super.wormAndFleaTreated,
    required super.accessCode,
  });

  factory PostModel.fromEntity(PostEntity entity) {
    return PostModel(
      quantity: entity.quantity,
      address: entity.address,
      isActive: entity.isActive,
      listId: entity.listId,
      currentLongitude: entity.currentLongitude,
      createdAt: entity.createdAt,
      discount: entity.discount,
      description: entity.description,
      fileUrls: entity.fileUrls,
      title: entity.title,
      type: entity.type,
      createdBy: entity.createdBy,
      acceptOffers: entity.acceptOffers,
      sizeColors: entity.sizeColors,
      currentLatitude: entity.currentLatitude,
      postId: entity.postId,
      deliveryType: entity.deliveryType,
      price: entity.price,
      minOfferAmount: entity.minOfferAmount,
      condition: entity.condition,
      sizeChartUrl: entity.sizeChartUrl,
      currency: entity.currency,
      privacy: entity.privacy,
      brand: entity.brand,
      collectionLatitude: entity.collectionLatitude,
      collectionLongitude: entity.collectionLongitude,
      collectionLocation: entity.collectionLocation,
      localDelivery: entity.localDelivery,
      internationalDelivery: entity.internationalDelivery,
      fuelType: entity.fuelType,
      doors: entity.doors,
      availability: entity.availability,
      emission: entity.emission,
      exteriorColor: entity.exteriorColor,
      seats: entity.seats,
      vehiclesCategory: entity.vehiclesCategory,
      meetUpLocation: entity.meetUpLocation,
      interiorColor: entity.interiorColor,
      transmission: entity.transmission,
      mileage: entity.mileage,
      model: entity.model,
      engineSize: entity.engineSize,
      make: entity.make,
      bodyType: entity.bodyType,
      mileageUnit: entity.mileageUnit,
      year: entity.year,
      petsCategory: entity.petsCategory,
      healthChecked: entity.healthChecked,
      breed: entity.breed,
      age: entity.age,
      vaccinationUpToDate: entity.vaccinationUpToDate,
      readyToLeave: entity.readyToLeave,
      wormAndFleaTreated: entity.wormAndFleaTreated,
      accessCode: entity.accessCode,
    );
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawDiscount = json['discount'];
    DiscountModel? disc;
    if (rawDiscount != null) {
      if (rawDiscount is Map<String, dynamic>) {
        disc = DiscountModel.fromJson(rawDiscount);
      }
    }
    return PostModel(
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      address: json['address'] ?? '',
      isActive: json['is_active'] ?? true,
      listId: json['list_id'],
      currentLongitude:
          double.tryParse(json['current_longitude']?.toString() ?? '0.0') ??
              0.0,
      createdAt:
          (json['created_at']?.toString() ?? '').toDateTime() ?? DateTime.now(),
      discount: disc,
      description: json['description'] ?? '',
      fileUrls:
          List<AttachmentModel>.from((json['file_urls'] ?? <dynamic>[]).map(
        (dynamic x) => AttachmentModel.fromJson(x),
      )),
      title: json['title'],
      type: ListingType.fromStrJson(json['type']),
      createdBy: json['created_by'],
      acceptOffers: json['accept_offers'],
      sizeColors: json['size_colors'] == null
          ? <SizeColorModel>[]
          : List<SizeColorModel>.from((json['size_colors'] ?? <dynamic>[]).map(
              (dynamic x) => SizeColorModel.fromJson(x),
            )),
      currentLatitude:
          double.tryParse(json['current_latitude']?.toString() ?? '0.0') ?? 0.0,
      postId: json['post_id'],
      deliveryType: DeliveryType.fromJson(json['delivery_type']),
      price: double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
      minOfferAmount:
          double.tryParse(json['min_offer_amount']?.toString() ?? '0.0') ?? 0.0,
      condition: ConditionType.fromJson(json['item_condition']),
      sizeChartUrl: json['size_chart_url'] == null ||
              json['size_chart_url'].runtimeType == String
          ? null
          : AttachmentModel.fromJson(json['size_chart_url']),
      currency: json['currency'],
      privacy: PrivacyType.fromJson(json['post_privacy']),
      brand: json['brand'] ?? '',
      collectionLatitude:
          double.tryParse(json['collection_latitude']?.toString() ?? '0.0') ??
              0.0,
      collectionLongitude:
          double.tryParse(json['collection_longitude']?.toString() ?? '0.0') ??
              0.0,
      collectionLocation: json['collection_location'] == null
          ? null
          : LocationModel.fromJson(json['collection_location']),
      localDelivery:
          int.tryParse(json['local_delivery']?.toString() ?? '0') ?? 0,
      internationalDelivery:
          int.tryParse(json['international_delivery']?.toString() ?? '0') ?? 0,
      fuelType: json['fuel_type'],
      doors: json['doors'],
      availability: json['availability'] == null
          ? <AvailabilityModel>[]
          : List<AvailabilityModel>.from((json['availability'] ?? <dynamic>[])
              .map((dynamic x) => AvailabilityModel.fromJson(x))),
      emission: json['emission'],
      exteriorColor: json['exterior_color'],
      seats: int.tryParse(json['seats']?.toString() ?? '0') ?? 0,
      vehiclesCategory: json['vehicles_category'],
      meetUpLocation: json['meet_up_location'] == null
          ? null
          : LocationModel.fromJson(json['meet_up_location']),
      interiorColor: json['interior_color'],
      transmission: json['transmission'],
      mileage: json['mileage'],
      model: json['model'],
      engineSize:
          double.tryParse(json['engine_size']?.toString() ?? '0.0') ?? 0.0,
      make: json['make'],
      bodyType: json['body_type'],
      mileageUnit: json['mileage_unit'],
      year: json['year'],
      petsCategory: json['pets_category'],
      healthChecked: BooleanStatusType.fromJson(json['health_checked']),
      breed: json['breed'],
      age: json['age'],
      vaccinationUpToDate:
          BooleanStatusType.fromJson(json['vaccination_up_to_date']),
      readyToLeave: json['ready_to_leave'],
      wormAndFleaTreated:
          BooleanStatusType.fromJson(json['worm_and_flea_treated']),
      accessCode: json['access_code'],
    );
  }
}
