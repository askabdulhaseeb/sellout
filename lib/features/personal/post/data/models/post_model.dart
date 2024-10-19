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

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawDiscount = json['discount'];
    DiscountModel? disc;
    if (rawDiscount != null && rawDiscount is Map<String, dynamic>) {
      disc = DiscountModel.fromJson(rawDiscount);
    }
    return PostModel(
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      address: json['address'],
      isActive: json['is_active'],
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
      sizeColors:
          List<SizeColorModel>.from((json['size_colors'] ?? <dynamic>[]).map(
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
      sizeChartUrl: json['size_chart_url'] ?? '',
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
      localDelivery: json['local_delivery'],
      internationalDelivery: json['international_delivery'],
      fuelType: json['fuel_type'],
      doors: json['doors'],
      availability: json['availability'] == null
          ? <AvailabilityModel>[]
          : List<AvailabilityModel>.from((json['availability'] ?? <dynamic>[])
              .map((dynamic x) => AvailabilityModel.fromJson(x))),
      emission: json['emission'],
      exteriorColor: json['exterior_color'],
      seats: json['seats'],
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
