import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../../core/extension/string_ext.dart';
import '../../../../../attachment/data/attchment_model.dart';
import '../../../../location/data/models/location_model.dart';
import '../../../domain/entities/discount_entity.dart';
import '../../../domain/entities/post/package_detail_entity.dart';
import '../../../domain/entities/post/post_entity.dart';
import '../meetup/availability_model.dart';
import 'package_detail_model.dart';
import 'post_cloth_foot_model.dart';
import 'post_pet_model.dart';
import 'post_property_model.dart';
import 'post_vehicle_model.dart';

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
    required super.listOfReviews,
    required super.categoryType,
    required super.currentLongitude,
    required super.currentLatitude,
    required super.collectionLatitude,
    required super.collectionLongitude,
    required super.localDelivery,
    required super.internationalDelivery,
    required super.address,
    required super.collectionLocation,
    required super.fileUrls,
    required super.hasDiscount,
    required super.discounts,
    required super.clothFootInfo,
    required super.petInfo,
    required super.vehicleInfo,
    required super.propertyInfo,
    required super.packageDetail, // ADD THIS PARAMETER
    required super.meetUpLocation,
    required super.availability,
    required super.isActive,
    required super.createdBy,
    required super.updatedBy,
    required super.createdAt,
    required super.updatedAt,
    required super.accessCode,
  }) : super(inHiveAt: DateTime.now());

  factory PostModel.fromJson(Map<String, dynamic> json) {
    // Handle discount parsing
    final dynamic discountRaw = json['discount'];
    final Map<String, dynamic> discountData =
        (discountRaw is Map<String, dynamic>)
            ? discountRaw
            : <String, dynamic>{};
    final bool hasDiscount = discountRaw is bool
        ? discountRaw
        : discountData.isNotEmpty &&
            discountData.values.any((value) => (value as int? ?? 0) > 0);

    final List<DiscountEntity> discounts = <DiscountEntity>[];
    if (hasDiscount) {
      final double d2 =
          double.tryParse(json['discount_2_item']?.toString() ?? '0.0') ?? 0.0;
      final double d3 =
          double.tryParse(json['discount_3_item']?.toString() ?? '0.0') ?? 0.0;
      final double d5 =
          double.tryParse(json['discount_5_item']?.toString() ?? '0.0') ?? 0.0;
      if (d2 > 0) discounts.add(DiscountEntity(quantity: 2, discount: d2));
      if (d3 > 0) discounts.add(DiscountEntity(quantity: 3, discount: d3));
      if (d5 > 0) discounts.add(DiscountEntity(quantity: 5, discount: d5));
    }

    // Parse package detail
    final PackageDetailEntity packageDetail = json['package_detail'] != null
        ? PackageDetailModel.fromJson(json['package_detail'])
        : PackageDetailModel.empty;

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
      categoryType: json['type']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      acceptOffers:
          bool.tryParse(json['accept_offers']?.toString() ?? 'false') ?? false,
      minOfferAmount:
          double.tryParse(json['min_offer_amount']?.toString() ?? '0.0') ?? 0.0,
      privacy: PrivacyType.fromJson(json['post_privacy']),
      condition: ConditionType.fromJson(json['item_condition']),
      deliveryType: DeliveryType.fromJson(json['delivery_type']),
      listOfReviews: List<double>.from(
        (json['list_of_reviews'] ?? <dynamic>[]).map((dynamic x) {
          if (x is int) return x.toDouble();
          if (x is double) return x;
          return double.tryParse(x.toString()) ?? 0.0;
        }),
      ),
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
      localDelivery:
          int.tryParse(json['local_delivery']?.toString() ?? '0') ?? 0,
      internationalDelivery:
          int.tryParse(json['international_delivery']?.toString() ?? '0') ?? 0,
      fileUrls: (json['file_urls'] ?? <dynamic>[])
          .map<AttachmentModel>((dynamic e) => AttachmentModel.fromJson(e))
          .toList(),
      hasDiscount: hasDiscount,
      discounts: discounts,
      clothFootInfo: PostClothFootModel.fromJson(json),
      petInfo: PostPetModel.fromJson(json),
      vehicleInfo: PostVehicleModel.fromJson(json),
      propertyInfo: PostPropertyModel.fromJson(json),
      packageDetail: packageDetail, // ADD THIS LINE
      meetUpLocation: json['meet_up_location'] == null
          ? null
          : LocationModel.fromJson(json['meet_up_location']),
      availability: (json['availability'] ?? <dynamic>[])
          .map<AvailabilityModel>((dynamic e) => AvailabilityModel.fromJson(e))
          .toList(),
      isActive: (json['is_active'] is bool)
          ? json['is_active']
          : json['is_active'].toString().toLowerCase() != 'false',
      createdBy: json['created_by']?.toString() ?? '',
      updatedBy: json['updated_by']?.toString() ?? '',
      createdAt: json['created_at']?.toString().toDateTime() ?? DateTime.now(),
      updatedAt: json['updated_at']?.toString().toDateTime() ?? DateTime.now(),
      accessCode: json['access_code']?.toString(),
    );
  }
}
