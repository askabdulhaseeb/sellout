import '../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../core/extension/string_ext.dart';
import '../../../../attachment/data/attchment_model.dart';
import '../../../location/data/models/location_model.dart';
import '../../domain/entities/discount_entity.dart';
import '../../domain/entities/post_entity.dart';
import 'meetup/availability_model.dart';
import 'size_color/size_color_model.dart';

class PostModel extends PostEntity {
  PostModel({
    required super.listID,
    required super.postID,
    required super.businessID,
    required super.title,
    required super.description,
    required super.price,
    required super.quantity,
    required super.currency,
    required super.type,
    required super.acceptOffers,
    required super.minOfferAmount,
    required super.privacy,
    required super.condition,
    required super.deliveryType,
    //
    required super.currentLongitude,
    required super.currentLatitude,
    required super.collectionLatitude,
    required super.collectionLongitude,
    //
    required super.localDelivery,
    required super.internationalDelivery,
    //
    required super.address,
    required super.collectionLocation,
    //
    required super.sizeChartUrl,
    required super.fileUrls,
    required super.hasDiscount,
    required super.discounts,
    required super.sizeColors,
    //
    required super.year,
    required super.doors,
    required super.seats,
    required super.mileage,
    required super.make,
    required super.model,
    required super.brand,
    required super.bodyType,
    required super.emission,
    required super.fuelType,
    required super.engineSize,
    required super.mileageUnit,
    required super.transmission,
    required super.interiorColor,
    required super.exteriorColor,
    required super.vehiclesCategory,
    required super.meetUpLocation,
    required super.availability,
    //
    required super.age,
    required super.breed,
    required super.healthChecked,
    required super.petsCategory,
    required super.readyToLeave,
    required super.wormAndFleaTreated,
    required super.vaccinationUpToDate,
    //
    required super.isActive,
    required super.createdBy,
    required super.updatedBy,
    required super.createdAt,
    required super.updatedAt,
    required super.accessCode,
  }) : super(inHiveAt: DateTime.now());

  factory PostModel.fromEntity(PostEntity entity) {
    return PostModel(
      listID: entity.listID,
      postID: entity.postID,
      businessID: entity.businessID,
      title: entity.title,
      description: entity.description,
      price: entity.price,
      quantity: entity.quantity,
      currency: entity.currency,
      type: entity.type,
      address: entity.address,
      acceptOffers: entity.acceptOffers,
      minOfferAmount: entity.minOfferAmount,
      privacy: entity.privacy,
      condition: entity.condition,
      deliveryType: entity.deliveryType,
      //
      currentLongitude: entity.currentLongitude,
      currentLatitude: entity.currentLatitude,
      collectionLatitude: entity.collectionLatitude,
      collectionLongitude: entity.collectionLongitude,
      collectionLocation: entity.collectionLocation,
      //
      localDelivery: entity.localDelivery,
      internationalDelivery: entity.internationalDelivery,
      //
      sizeChartUrl: entity.sizeChartUrl,
      fileUrls: entity.fileUrls,
      hasDiscount: entity.hasDiscount,
      discounts: entity.discounts,
      sizeColors: entity.sizeColors,
      //
      year: entity.year,
      doors: entity.doors,
      seats: entity.seats,
      mileage: entity.mileage,
      make: entity.make,
      model: entity.model,
      brand: entity.brand,
      bodyType: entity.bodyType,
      emission: entity.emission,
      fuelType: entity.fuelType,
      engineSize: entity.engineSize,
      mileageUnit: entity.mileageUnit,
      transmission: entity.transmission,
      interiorColor: entity.interiorColor,
      exteriorColor: entity.exteriorColor,
      vehiclesCategory: entity.vehiclesCategory,
      meetUpLocation: entity.meetUpLocation,
      availability: entity.availability,
      //
      age: entity.age,
      breed: entity.breed,
      healthChecked: entity.healthChecked,
      petsCategory: entity.petsCategory,
      readyToLeave: entity.readyToLeave,
      wormAndFleaTreated: entity.wormAndFleaTreated,
      vaccinationUpToDate: entity.vaccinationUpToDate,
      //
      isActive: entity.isActive,
      createdBy: entity.createdBy,
      updatedBy: entity.updatedBy,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      accessCode: entity.accessCode,
    );
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final List<DiscountEntity> discounts = <DiscountEntity>[];
    final bool hasDiscount =
        bool.tryParse(json['discount']?.toString() ?? 'false') ?? false;
    if (hasDiscount) {
      final double d2 =
          double.tryParse(json['discount_2_item']?.toString() ?? '0.0') ?? 0.0;
      final double d3 =
          double.tryParse(json['discount_3_item']?.toString() ?? '0.0') ?? 0.0;
      final double d5 =
          double.tryParse(json['discount_5_item']?.toString() ?? '0.0') ?? 0.0;
      if (d2 > 0) {
        discounts.add(DiscountEntity(quantity: 2, discount: d2));
      }
      if (d3 > 0) {
        discounts.add(DiscountEntity(quantity: 3, discount: d3));
      }
      if (d5 > 0) {
        discounts.add(DiscountEntity(quantity: 5, discount: d5));
      }
    }
    return PostModel(
      listID: json['list_id']?.toString() ?? '',
      postID: json['post_id']?.toString() ?? '',
      businessID: json['business_id']?.toString(),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      currency: json['currency']?.toString() ?? 'gbp',
      type: ListingType.fromJson(json['list_id']),
      address: json['address']?.toString() ?? '',
      acceptOffers:
          bool.tryParse(json['accept_offers']?.toString() ?? 'false') ?? false,
      minOfferAmount:
          double.tryParse(json['min_offer_amount']?.toString() ?? '0.0') ?? 0.0,
      privacy: PrivacyType.fromJson(json['post_privacy']),
      condition: ConditionType.fromJson(json['item_condition']),
      deliveryType: DeliveryType.fromJson(json['delivery_type']),
      //
      currentLongitude:
          double.tryParse(json['current_longitude']?.toString() ?? '0.0') ??
              0.0,
      currentLatitude:
          double.tryParse(json['current_latitude']?.toString() ?? '0.0') ?? 0.0,
      collectionLatitude:
          double.tryParse(json['collection_latitude']?.toString() ?? '0.0') ??
              0.0,
      collectionLongitude:
          double.tryParse(json['collection_longitude']?.toString() ?? '0.0') ??
              0.0,
      collectionLocation: json['collection_location'] == null
          ? null
          : LocationModel.fromJson(json['collection_location']),
      //
      localDelivery:
          int.tryParse(json['local_delivery']?.toString() ?? '0') ?? 0,
      internationalDelivery:
          int.tryParse(json['international_delivery']?.toString() ?? '0') ?? 0,
      //
      sizeChartUrl: json['size_chart'] == null
          ? null
          : AttachmentModel.fromJson(json['size_chart']),
      fileUrls: (json['file_urls'] ?? <dynamic>[])
          ?.map<AttachmentModel>((dynamic e) => AttachmentModel.fromJson(e))
          .toList(),
      hasDiscount: hasDiscount,
      discounts: discounts,
      sizeColors: (json['size_colors'] ?? <dynamic>[])
          ?.map<SizeColorModel>((dynamic e) => SizeColorModel.fromJson(e))
          .toList(),
      //
      year: json['year'],
      doors: json['doors'],
      seats: json['seats'],
      mileage: json['mileage'],
      make: json['make']?.toString(),
      model: json['model']?.toString(),
      brand: json['brand']?.toString(),
      bodyType: json['body_type']?.toString(),
      emission: json['emission']?.toString(),
      fuelType: json['fuel_type']?.toString(),
      engineSize:
          double.tryParse(json['engine_size']?.toString() ?? '0.0') ?? 0.0,
      mileageUnit: json['mileage_unit']?.toString(),
      transmission: json['transmission']?.toString(),
      interiorColor: json['interior_color']?.toString(),
      exteriorColor: json['exterior_color']?.toString(),
      vehiclesCategory: json['vehicles_category']?.toString(),
      meetUpLocation: json['meet_up_location'] == null
          ? null
          : LocationModel.fromJson(json['meet_up_location']),
      availability: (json['availability'] ?? <dynamic>[])
          .map<AvailabilityModel>((dynamic e) => AvailabilityModel.fromJson(e))
          .toList(),
      //
      age: json['age']?.toString(),
      breed: json['breed']?.toString(),
      healthChecked: json['health_checked'] ?? false,
      petsCategory: json['pets_category']?.toString(),
      readyToLeave: json['ready_to_leave']?.toString(),
      wormAndFleaTreated: json['worm_and_flea_treated'] ?? false,
      vaccinationUpToDate: json['vaccination_up_to_date'] ?? false,
      //
      isActive: bool.tryParse(json['is_active'] ?? 'false') ?? false,
      createdBy: json['created_by']?.toString() ?? '',
      updatedBy: json['updated_by']?.toString() ?? '',
      createdAt: json['created_at']?.toString().toDateTime() ?? DateTime.now(),
      updatedAt: json['updated_at']?.toString().toDateTime() ?? DateTime.now(),
      accessCode: json['access_code']?.toString(),
    );
  }
}
