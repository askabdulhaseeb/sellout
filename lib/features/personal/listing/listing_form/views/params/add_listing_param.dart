import 'dart:convert';
import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../../core/enums/listing/property/tenure_type.dart';
import '../../../../../attachment/data/attchment_model.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../location/data/models/location_model.dart';
import '../../../../location/domain/entities/location_entity.dart';
import '../../../../post/data/models/post/package_detail_model.dart';
import '../../../../post/data/models/size_color/color_model.dart';
import '../../../../post/data/models/size_color/size_color_model.dart';
import '../../../../post/domain/entities/discount_entity.dart';
import '../../../../post/domain/entities/post/package_detail_entity.dart';
import '../../../../post/domain/entities/post/post_cloth_foot_entity.dart';
import '../../../../post/domain/entities/post/post_pet_entity.dart';
import '../../../../post/domain/entities/post/post_property_entity.dart';
import '../../../../post/domain/entities/post/post_vehicle_entity.dart';
import '../../../../post/domain/entities/size_color/color_entity.dart';
import '../../../../post/domain/entities/size_color/size_color_entity.dart';
import '../../domain/entities/sub_category_entity.dart';

class AddListingParam {
  AddListingParam({
    required this.title,
    required this.description,
    required this.attachments,
    required this.price,
    required this.acceptOffer,
    required this.minOfferAmount,
    required this.privacyType,
    required this.deliveryType,
    required this.listingType,
    required this.currency,
    this.packageDetail,
    this.condition,
    this.type,
    this.category,
    this.quantity,
    this.discount,
    this.accessCode,
    this.postID,
    this.oldAttachments,
    this.clothfootParams,
    this.discounts,
    this.vehicleParams,
    this.propertyParams,
    this.petsParams,
    this.meetUpLocation,
    this.collectionLocation,
    this.currentLatitude,
    this.currentLongitude,
    this.availbility,
  });

  // Core fields
  final String title;
  final String description;
  final List<PickedAttachment> attachments;
  final String price;
  final String? quantity;
  final bool? discount;
  final ConditionType? condition;
  final bool acceptOffer;
  final String minOfferAmount;
  final PrivacyType privacyType;
  final DeliveryType deliveryType;
  final ListingType listingType;
  final String currency;
  final SubCategoryEntity? category;
  final PackageDetailEntity? packageDetail;

  // Location / meta
  final num? currentLatitude;
  final num? currentLongitude;
  final String? type;
  final List<DiscountEntity>? discounts;
  final String? accessCode;
  final String? postID;
  final List<AttachmentEntity>? oldAttachments;
  final String? availbility;

  // Specialized params (nullable because not every listing uses them)
  final PostClothFootEntity? clothfootParams;
  final PostVehicleEntity? vehicleParams;
  final PostPropertyEntity? propertyParams;
  final PostPetEntity? petsParams;

  final LocationEntity? meetUpLocation;
  final LocationEntity? collectionLocation;

  String get acceptOfferJSON => acceptOffer ? 'true' : 'false';

  Map<String, String> toMap() {
    switch (listingType) {
      case ListingType.items:
        return _item();
      case ListingType.clothAndFoot:
        return _cloth();
      case ListingType.foodAndDrink:
        return _food();
      case ListingType.vehicle:
        return _vehicles();
      case ListingType.property:
        return _property();
      case ListingType.pets:
        return _pet();
    }
  }

  // --- Helpers ---
  DiscountEntity? _discountFor(int qty) {
    if (discounts == null) return null;
    try {
      return discounts!.firstWhere((e) => e.quantity == qty);
    } catch (_) {
      return null;
    }
  }

  Map<String, String> _titleMAP() {
    return <String, String>{
      'title': title,
      'description': description,
      'price': price,
      if (postID == null) 'currency': currency,
      'post_privacy': privacyType.json,
      if (privacyType == PrivacyType.private) 'access_code': accessCode ?? '',
      if (postID != null && (oldAttachments?.isNotEmpty ?? false))
        'old_files': jsonEncode(oldAttachments!
            .map((AttachmentEntity attachment) =>
                AttachmentModel.fromEntity(attachment).toJson())
            .toList()),
    };
  }

  Map<String, String> _discountMAP() {
    final Map<String, String> data = <String, String>{
      'discount': (discount ?? false).toString()
    };

    if (discount == true) {
      final DiscountEntity? d2 = _discountFor(2);
      final DiscountEntity? d3 = _discountFor(3);
      final DiscountEntity? d5 = _discountFor(5);
      if (d2 != null) data['disc_2_items'] = d2.discount.toString();
      if (d3 != null) data['disc_3_items'] = d3.discount.toString();
      if (d5 != null) data['disc_5_items'] = d5.discount.toString();
    }

    return data;
  }

  Map<String, String> _offerMAP() {
    final Map<String, String> data = <String, String>{
      'accept_offers': acceptOfferJSON
    };
    if (acceptOffer) data['min_offer_amount'] = minOfferAmount;
    return data;
  }

  Map<String, String> _deliveryMAP() {
    final Map<String, String> data = <String, String>{
      'delivery_type': deliveryType.json
    };

    if (deliveryType == DeliveryType.paid ||
        deliveryType == DeliveryType.freeDelivery) {
      data['package_detail'] = packageDetail != null
          ? jsonEncode(PackageDetailModel.fromEntity(packageDetail!).toMap())
          : '';
    }

    if (deliveryType == DeliveryType.collection) {
      data['collection_location'] = collectionLocation != null
          ? jsonEncode(
              LocationModel.fromEntity(collectionLocation!).toJsonidurlkeys())
          : '';
    }

    return data;
  }

  Map<String, String> _listLocMAP() {
    return <String, String>{
      'list_id': listingType.json,
      'current_latitude': currentLatitude?.toString() ?? '',
      'current_longitude': currentLongitude?.toString() ?? '',
    };
  }

  Map<String, String> _meetupMAP() {
    return <String, String>{
      'meet_up_location': meetUpLocation != null
          ? jsonEncode(
              LocationModel.fromEntity(meetUpLocation!).toJsonidurlkeys())
          : '',
      'availability': availbility ?? '',
    };
  }

  Map<String, String> _baseMap({
    bool includeDiscount = false,
    bool includeOffer = false,
    bool includeDelivery = false,
    bool includeListLoc = false,
    bool includeMeetup = false,
  }) {
    final Map<String, String> data = <String, String>{};
    data.addAll(_titleMAP());
    if (includeDiscount) data.addAll(_discountMAP());
    if (includeOffer) data.addAll(_offerMAP());
    if (includeDelivery) data.addAll(_deliveryMAP());
    if (includeListLoc) data.addAll(_listLocMAP());
    if (includeMeetup) data.addAll(_meetupMAP());
    return data;
  }

  Map<String, String> _item() {
    final Map<String, String> data = <String, String>{
      'quantity': quantity ?? '1',
      'item_condition': condition?.json ?? '',
    };
    data.addAll(_baseMap(
      includeDiscount: true,
      includeOffer: true,
      includeDelivery: true,
      includeListLoc: true,
    ));
    return data;
  }

  Map<String, String> _cloth() {
    final List<Map<String, dynamic>> sizeColorsJson =
        (clothfootParams?.sizeColors ?? <SizeColorEntity>[])
            .map((SizeColorEntity e) => SizeColorModel(
                  value: e.value,
                  colors: e.colors
                      .map((ColorEntity c) => ColorModel.fromEntity(c))
                      .toList(),
                  id: e.id,
                ).toMap())
            .toList();

    final Map<String, String> data = <String, String>{
      'quantity': quantity ?? '',
      'item_condition': condition?.json ?? '',
      'brand': clothfootParams?.brand ?? '',
      'size_colors': jsonEncode(sizeColorsJson),
      'type': type ?? '',
    };

    data.addAll(_baseMap(
      includeDiscount: true,
      includeOffer: true,
      includeDelivery: true,
      includeListLoc: true,
    ));
    return data;
  }

  Map<String, String> _food() {
    final Map<String, String> data = <String, String>{
      'quantity': quantity ?? ''
    };
    data.addAll(_baseMap(
      includeDiscount: true,
      includeOffer: true,
      includeDelivery: true,
      includeListLoc: true,
    ));
    return data;
  }

  Map<String, String> _vehicles() {
    final Map<String, String> data = <String, String>{
      'item_condition': condition?.json ?? '',
      'make': vehicleParams?.make ?? '',
      'model': vehicleParams?.model ?? '',
      'body_type': vehicleParams?.bodyType ?? '',
      'emission': vehicleParams?.emission ?? '',
      'year': vehicleParams?.year?.toString() ?? '',
      'colour': vehicleParams?.exteriorColor ?? '',
      'engine_size': vehicleParams?.engineSize?.toString() ?? '',
      'mileage': vehicleParams?.mileage?.toString() ?? '',
      'doors': vehicleParams?.doors?.toString() ?? '',
      'seats': vehicleParams?.seats?.toString() ?? '',
      'transmission': vehicleParams?.transmission ?? '',
      'author_name': LocalAuth.currentUser?.userName ?? '',
      'mileage_unit': vehicleParams?.mileageUnit ?? '',
      'vehicles_category': vehicleParams?.vehiclesCategory ?? '',
      'fuel_type': vehicleParams?.fuelType ?? '',
    };

    data.addAll(_baseMap(
      includeOffer: true,
      includeListLoc: true,
      includeMeetup: true,
    ));
    return data;
  }

  Map<String, String> _property() {
    final Map<String, String> data = <String, String>{
      'property_category': propertyParams?.propertyCategory ?? '',
      'bedrooms': propertyParams?.bedroom?.toString() ?? '',
      'bathrooms': propertyParams?.bathroom?.toString() ?? '',
      'energy_rating': propertyParams?.energyRating ?? '',
      'garden': (propertyParams?.garden ?? false).toString(),
      'parking': (propertyParams?.parking ?? false).toString(),
      'tenure_type':
          (propertyParams?.tenureType as TenureType?)?.toJson() ?? '',
      'property_type': propertyParams?.propertyType ?? '',
    };

    data.addAll(_baseMap(
      includeListLoc: true,
      includeMeetup: true,
    ));
    return data;
  }

  Map<String, String> _pet() {
    final Map<String, String> data = <String, String>{
      'quantity': quantity ?? '1',
      'age': petsParams?.age ?? '',
      'ready_to_leave': petsParams?.readyToLeave ?? '',
      'breed': petsParams?.breed ?? '',
      'health_checked': (petsParams?.healthChecked ?? false).toString(),
      'vaccination_up_to_date':
          (petsParams?.vaccinationUpToDate ?? false).toString(),
      'worm_and_flea_treated':
          (petsParams?.wormAndFleaTreated ?? false).toString(),
      'pets_category': petsParams?.petsCategory ?? '',
    };

    data.addAll(_baseMap(
      includeOffer: true,
      includeListLoc: true,
    ));
    return data;
  }
}
