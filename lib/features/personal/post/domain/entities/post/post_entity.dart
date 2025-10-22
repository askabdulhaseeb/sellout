import 'package:hive/hive.dart';
import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../location/domain/entities/location_entity.dart';
import '../discount_entity.dart';
import '../meetup/availability_entity.dart';
import 'package_detail_entity.dart';
import 'post_cloth_foot_entity.dart';
import 'post_food_drink_entity.dart';
import 'post_pet_entity.dart';
import 'post_property_entity.dart';
import 'post_vehicle_entity.dart';
part 'post_entity.g.dart';

@HiveType(typeId: 20)
class PostEntity {
  PostEntity({
    required this.listID,
    required this.postID,
    required this.businessID,
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
    required this.currency,
    required this.type,
    required this.acceptOffers,
    required this.minOfferAmount,
    required this.privacy,
    required this.condition,
    required this.listOfReviews,
    required this.categoryType,
    //
    required this.currentLongitude,
    required this.currentLatitude,
    required this.collectionLatitude,
    required this.collectionLongitude,
    required this.collectionLocation,
    required this.meetUpLocation,
    //delivery
    required this.deliveryType,
    required this.localDelivery,
    required this.internationalDelivery,
    //
    required this.availability,
    //
    required this.fileUrls,
    //
    required this.hasDiscount,
    required this.discounts,
    //cloth foot
    required this.clothFootInfo,
    //property
    required this.propertyInfo,
    //pets
    required this.petInfo,
    //vehicle
    required this.vehicleInfo,
    //Food Drink
    required this.foodDrinkInfo,
    //package detail - ADD THIS FIELD
    required this.packageDetail,
    //
    required this.isActive,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.accessCode,
    DateTime? inHiveAt,
  }) : inHiveAt = inHiveAt ?? DateTime.now();

  @HiveField(0)
  final String listID;
  @HiveField(1)
  final String postID;
  @HiveField(2)
  final String? businessID;
  @HiveField(3)
  final String title;
  @HiveField(4)
  final String description;
  @HiveField(5)
  final double price;
  @HiveField(6)
  final int quantity;
  @HiveField(7)
  final String? currency;
  @HiveField(8)
  final ListingType type;
  @HiveField(10)
  final bool acceptOffers;
  @HiveField(11)
  final double minOfferAmount;
  @HiveField(12)
  final PrivacyType privacy;
  @HiveField(13)
  final ConditionType condition;
  @HiveField(14)
  final DeliveryType deliveryType;
  @HiveField(15)
  final List<double>? listOfReviews;
  @HiveField(16)
  final String categoryType;
  @HiveField(17)
  final List<AttachmentEntity> fileUrls;
  //
  @HiveField(18)
  final List<DiscountEntity> discounts;
  @HiveField(19)
  final bool hasDiscount;
  //
  @HiveField(20)
  final double currentLongitude;
  @HiveField(21)
  final double currentLatitude;
  @HiveField(22)
  final double? collectionLatitude;
  @HiveField(23)
  final double? collectionLongitude;
  @HiveField(24)
  final LocationEntity? collectionLocation;
  @HiveField(25)
  final LocationEntity? meetUpLocation;
  //
  @HiveField(26)
  final int? localDelivery;
  @HiveField(27)
  final int? internationalDelivery;
  //
  @HiveField(28)
  final PostClothFootEntity? clothFootInfo;
  //
  @HiveField(29)
  final PostVehicleEntity? vehicleInfo;
  //
  @HiveField(30)
  final PostPetEntity? petInfo;
  //
  @HiveField(31)
  final PostPropertyEntity? propertyInfo;
  //
  @HiveField(32)
  final PostFoodDrinkEntity? foodDrinkInfo;

  @HiveField(33) // NEW FIELD - Package Detail
  final PackageDetailEntity packageDetail;
  //
  @HiveField(34)
  final List<AvailabilityEntity>? availability;
  @HiveField(35)
  final bool isActive;
  @HiveField(36)
  final String createdBy;
  @HiveField(37)
  final DateTime createdAt;
  @HiveField(38)
  final String? accessCode;
  @HiveField(39, defaultValue: '')
  final String updatedBy;
  @HiveField(40, defaultValue: null)
  final DateTime? updatedAt;
  @HiveField(41)
  final DateTime inHiveAt;

  String get imageURL => fileUrls.isEmpty ? '' : fileUrls.first.url;
  String get priceStr =>
      '${CountryHelper.currencySymbolHelper(currency)}$price'.toUpperCase();
  double get discountedPrice {
    if (hasDiscount) {
      if (discounts.isEmpty) return price;
      final DiscountEntity dis = discounts.last;
      return price - (price * dis.discount / 100);
    }
    return price;
  }

  // Package detail helper methods
  String get packageDimensions =>
      '${packageDetail.length}L x ${packageDetail.width}W x ${packageDetail.height}H';
  double get packageVolume => packageDetail.volume;
}
