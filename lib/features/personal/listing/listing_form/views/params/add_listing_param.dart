import 'dart:convert';

import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../../core/enums/listing/pet/age_time_type.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../post/data/models/size_color/size_color_model.dart';
import '../../../../post/domain/entities/discount_entity.dart';
import '../../domain/entities/sub_category_entity.dart';

class AddListingParam {
  AddListingParam({
    required this.businessID,
    required this.title,
    required this.description,
    required this.attachments,
    required this.price,
    required this.condition,
    required this.acceptOffer,
    required this.minOfferAmount,
    required this.privacyType,
    required this.deliveryType,
    required this.listingType,
    required this.currency,
    this.currentLatitude,
    this.currentLongitude,
    this.type,
    this.localDeliveryAmount,
    this.internationalDeliveryAmount,
    this.category,
    this.quantity,
    this.discount,
    this.accessCode,
    this.postID,
    this.oldAttachments,
    // clothfoot
    this.brand,
    this.sizeColor,
    this.discounts,
    // vehicle
    this.make,
    this.model,
    this.emission,
    this.bodyType,
    this.doors,
    this.seats,
    this.meetUpLocation,
    this.year,
    this.color,
    this.availbility,
    this.mileage,
    this.engineSize,
    this.vehicleCategory,
    this.milageUnit,
    this.transmission,
    // property
    this.propertyCategory,
    this.bedrooms,
    this.bathrooms,
    this.energyrating,
    this.garden,
    this.parking,
    this.tenureType,
    this.propertyType,
    this.animalFriendly,
    // pets
    this.age,
    this.readyToLeave,
    this.breed,
    this.healthChecked,
    this.vaccinationUpToDate,
    this.wormAndFleaTreated,
    this.petsCategory,
  });
  //
  final String? businessID;
  final String title;
  final String description;
  final List<PickedAttachment> attachments;
  final String price;
  final String? quantity;
  final bool? discount;
  final ConditionType condition;
  final bool acceptOffer;
  final String minOfferAmount;
  final PrivacyType privacyType;
  final DeliveryType deliveryType;
  final String? localDeliveryAmount;
  final String? internationalDeliveryAmount;
  final ListingType listingType;
  final SubCategoryEntity? category;
  final String? currency;
  final int? currentLatitude;
  final int? currentLongitude;
  final String? brand;
  final String? type;
  final List<SizeColorModel>? sizeColor;
  final List<DiscountEntity>? discounts;

  final String? accessCode;
  final String? postID;
  final List<AttachmentEntity>? oldAttachments;
//vehicle
  final String? make;
  final String? model;
  final String? emission;
  final String? bodyType;
  final String? doors;
  final String? seats;
  final Map<String, dynamic>? meetUpLocation;
  final String? year;
  final String? color;
  final String? availbility;
  final String? mileage;
  final String? engineSize;
  final String? vehicleCategory;
  final String? milageUnit;
  final String? transmission;
  //property
  final String? propertyCategory;
  final String? bedrooms;
  final String? bathrooms;
  final String? energyrating;
  final String? garden;
  final String? parking;
  final String? tenureType;
  final String? propertyType;
  final String? animalFriendly;
  //pets
  final AgeTimeType? age;
  final String? readyToLeave;
  final String? breed;
  final bool? healthChecked;
  final bool? vaccinationUpToDate;
  final bool? wormAndFleaTreated;
  final String? petsCategory;

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

  Map<String, String> _titleMAP() {
    return <String, String>{
      if (businessID != null) 'business_id': businessID ?? '',
      'title': title,
      'description': description,
      'price': price,
      'post_privacy': privacyType.json,
      if (privacyType == PrivacyType.private) 'access_code': accessCode ?? ''
    };
  }

  Map<String, String> _discountMAP() {
    return <String, String>{
      'discount': discount.toString(),
      if (discount == true)
        'disc_2_items': discounts!
            .firstWhere((DiscountEntity e) => e.quantity == 2)
            .discount
            .toString(),
      if (discount == true)
        'disc_3_items': discounts!
            .firstWhere((DiscountEntity e) => e.quantity == 3)
            .discount
            .toString(),
      if (discount == true)
        'disc_5_items': discounts!
            .firstWhere((DiscountEntity e) => e.quantity == 5)
            .discount
            .toString(),
    };
  }

  Map<String, String> _offerMAP() {
    return <String, String>{
      'accept_offers': acceptOfferJSON,
      if (acceptOffer == true) 'min_offer_amount': minOfferAmount,
    };
  }

  Map<String, String> _deliveryMAP() {
    return <String, String>{
      'delivery_type': deliveryType.json,
      if (deliveryType == DeliveryType.paid)
        'local_delivery': localDeliveryAmount ?? '0',
      if (deliveryType == DeliveryType.paid)
        'international_delivery': internationalDeliveryAmount ?? '0',
    };
  }

  Map<String, String> _listLocMAP() {
    return <String, String>{
      'list_id': listingType.json,
      'address': category?.address ?? '',
      if (currency != null) 'currency': currency ?? '',
      'current_latitude': currentLatitude.toString(),
      'current_longitude': currentLongitude.toString(),
    };
  }

  Map<String, String> _meetupMAP() {
    return <String, String>{
      'meet_up_location': jsonEncode(meetUpLocation),
      'availability': availbility ?? '',
    };
  }

  _item() {
    final Map<String, String> mapp = <String, String>{
      'quantity': quantity ?? '2',
      'item_condition': condition.json,
//      if (postID != null) 'old_file': oldAttachments.toString(),
    };
    mapp.addAll(_titleMAP());
    mapp.addAll(_discountMAP());
    mapp.addAll(_offerMAP());
    mapp.addAll(_deliveryMAP());
    mapp.addAll(_listLocMAP());
    return mapp;
  }

  _cloth() {
    final Map<String, String> mapp = <String, String>{
      'quantity': quantity ?? '',
      'item_condition': condition.json,
      'brand': brand ?? '',
      'size_colors': sizeColor.toString(), //
      'type': type ?? '', //
//      if (postID != null) 'old_file': oldAttachments.toString(),
    };
    mapp.addAll(_titleMAP());
    mapp.addAll(_discountMAP());
    mapp.addAll(_offerMAP());
    mapp.addAll(_deliveryMAP());
    mapp.addAll(_listLocMAP());
    return mapp;
  }

  _food() {
    final Map<String, String> mapp = <String, String>{
      'quantity': quantity ?? '',
      'delivery_type': deliveryType.json,
//      if (postID != null) 'old_file': oldAttachments.toString(),
    };
    mapp.addAll(_titleMAP());
    mapp.addAll(_discountMAP());
    mapp.addAll(_offerMAP());
    mapp.addAll(_deliveryMAP());
    mapp.addAll(_listLocMAP());
    return mapp;
  }

  _vehicles() {
    final Map<String, String> mapp = <String, String>{
      'item_condition': condition.json,
      'make': make ?? '', //
      'model': model ?? '', //
      'body_type': bodyType ?? '', //
      'emission': emission ?? '', //
      'year': year ?? '', //
      'colour': color ?? '', //
      'engine_size': engineSize ?? '', //
      'mileage': mileage ?? '', //
      'doors': doors ?? '', //
      'seats': seats ?? '', //
      'transmission': transmission ?? '', //
      'author_name': LocalAuth.currentUser?.username ?? '', //
      'created_by': LocalAuth.currentUser?.userID ?? '',
      'mileage_unit': milageUnit ?? '', //
      'vehicles_category': vehicleCategory ?? '', //
//      if (postID != null) 'old_file': oldAttachments.toString(),
    };
    mapp.addAll(_titleMAP());
    mapp.addAll(_offerMAP());
    mapp.addAll(_listLocMAP());
    mapp.addAll(_meetupMAP());
    return mapp;
  }

  _property() {
    final Map<String, String> mapp = <String, String>{
      'property_category': propertyCategory ?? '',
      'bedrooms': bedrooms.toString(),
      'bathrooms': bathrooms.toString(),
      'energy_rating': energyrating ?? '',
      'garden': garden ?? '',
      'parking': parking ?? '',
      'tenure_type': tenureType ?? '',
      'property_type': propertyType ?? '',
//      if (postID != null) 'old_file': oldAttachments.toString(),

      // 'animal_friendly': animalFriendly ?? '',
      // 'created_by': LocalAuth.currentUser?.userID ?? '',
    };
    mapp.addAll(_titleMAP());
    mapp.addAll(_listLocMAP());
    mapp.addAll(_meetupMAP());
    return mapp;
  }

  _pet() {
    final Map<String, String> mapp = <String, String>{
      'quantity': quantity.toString(),
      'age': age?.json ?? '',
      'post_privacy': privacyType.json,
      'ready_to_leave': readyToLeave ?? '',
      'breed': breed ?? '',
      'health_checked': healthChecked.toString(),
      'vaccination_up_to_date': vaccinationUpToDate.toString(),
      'worm_and_flea_treated': wormAndFleaTreated.toString(),
      'pets_category': petsCategory ?? '',
//      if (postID != null) 'old_file': oldAttachments.toString(),
    };
    mapp.addAll(_titleMAP());
    mapp.addAll(_offerMAP());
    mapp.addAll(_listLocMAP());
    mapp.addAll(_meetupMAP());

    return mapp;
  }
}
