import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../post/data/models/size_color/size_color_model.dart';
import '../../domain/entities/sub_category_entity.dart';

class AddListingParam {
  AddListingParam({
    required this.businessID,
    required this.title,
    required this.description,
    required this.attachments,
    required this.price,
    required this.quantity,
    required this.discount,
    required this.condition,
    required this.acceptOffer,
    required this.minOfferAmount,
    required this.privacyType,
    required this.deliveryType,
    required this.localDeliveryAmount,
    required this.internationalDeliveryAmount,
    required this.listingType,
    required this.currency,
    required this.currentLatitude,
    required this.currentLongitude,
    required this.brand,
    required this.type,
    this.category,
    this.sizeColor,
    this.discount2Items,
    this.discount3Items,
    this.discount5Items,
  });

  final String? businessID;
  final String title;
  final String description;
  final List<PickedAttachment> attachments;
  final String price;
  final String quantity;
  final bool discount;
  final ConditionType condition;
  final bool acceptOffer;
  final String minOfferAmount;
  final PrivacyType privacyType;
  final DeliveryType deliveryType;
  final String localDeliveryAmount;
  final String internationalDeliveryAmount;
  final ListingType listingType;
  final SubCategoryEntity? category;
  final String currency;
  final String currentLatitude;
  final String currentLongitude;
  final String brand;
  final String type;
  final List<SizeColorModel>? sizeColor;
  final String? discount2Items;
  final String? discount3Items;
  final String? discount5Items;

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
    };
  }

  Map<String, String> _discountMAP() {
    return <String, String>{
      'discount': discount.toString(),
      'disc_2_items': discount2Items ?? '0',
      'disc_3_items': discount3Items ?? '0',
      'disc_5_items': discount5Items ?? '0',
    };
  }

  Map<String, String> _offerMAP() {
    return <String, String>{
      'accept_offers': acceptOfferJSON,
      'min_offer_amount': minOfferAmount,
    };
  }

  Map<String, String> _deliveryMAP() {
    return <String, String>{
      'delivery_type': deliveryType.json,
      if (
          //listingType != ListingType.clothAndFoot &&
          listingType != ListingType.pets)
        'local_delivery': localDeliveryAmount,
      if (
          //listingType != ListingType.clothAndFoot &&
          listingType != ListingType.pets)
        'international_delivery': internationalDeliveryAmount,
    };
  }

  Map<String, String> _listLocMAP() {
    return <String, String>{
      'list_id': listingType.json,
      'address': category?.address ?? '',
      'currency': currency,
      'current_latitude': currentLatitude,
      'current_longitude': currentLongitude,
    };
  }

  Map<String, String> _meetupMAP() {
    return <String, String>{
      'meet_up_location': '',
      'availability': '',
    };
  }

  _item() {
    final Map<String, String> mapp = <String, String>{
      'quantity': quantity,
      'item_condition': condition.json,
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
      'quantity': quantity,
      'item_condition': condition.json,
      'brand': brand,
      'size_colors': sizeColor.toString(), //
      'type': type, //
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
      'quantity': quantity,
      'delivery_type': deliveryType.json,
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
      'make': 'bmw', //
      'model': 'm3', //
      'body_type': 'Sedan', //
      'emission': 'euro_4', //
      'year': '2017', //
      'colour': 'black', //
      'engine_size': '2500', //
      'mileage': '12', //
      'doors': '4', //
      'seats': '4', //
      'transmission': 'auto', //
      'author_name': 'ahmed', //
      'created_by': 'hgkj876',
      'mileage_unit': 'miles', //
      'vehicles_category': 'cars', //
    };
    mapp.addAll(_titleMAP());
    mapp.addAll(_offerMAP());
    mapp.addAll(_listLocMAP());
    mapp.addAll(_meetupMAP());
    return mapp;
  }

  _property() {
    final Map<String, String> mapp = <String, String>{
      'property_category': 'sale',
      'bedrooms': '6',
      'bathrooms': '5',
      'energy_rating': '81to91',
      'garden': 'yes',
      'parking': 'yes',
      'tenure_type': 'free_hold',
      'property_type': 'detached',
    };
    mapp.addAll(_titleMAP());
    mapp.addAll(_listLocMAP());
    mapp.addAll(_meetupMAP());
    return mapp;
  }

  _pet() {
    final Map<String, String> mapp = <String, String>{
      'age': '1_week',
      'post_privacy': 'public',
      'ready_to_leave': 'now',
      'breed': 'Labrador',
      'health_checked': 'yes',
      'vaccination_up_to_date': 'yes',
      'worm_and_flea_treated': 'yes',
      'pets_category': 'dogs',
    };
    mapp.addAll(_titleMAP());
    mapp.addAll(_discountMAP());
    mapp.addAll(_offerMAP());
    mapp.addAll(_listLocMAP());
    mapp.addAll(_meetupMAP());
    return mapp;
  }
}
