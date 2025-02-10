import 'package:hive/hive.dart';

import '../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../location/domain/entities/location_entity.dart';
import 'discount_entity.dart';
import 'meetup/availability_entity.dart';
import 'size_color/size_color_entity.dart';
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
    required this.address,
    required this.acceptOffers,
    required this.minOfferAmount,
    required this.privacy,
    required this.condition,
    required this.deliveryType,
    //
    required this.currentLongitude,
    required this.currentLatitude,
    required this.collectionLatitude,
    required this.collectionLongitude,
    required this.collectionLocation,
    //
    required this.localDelivery,
    required this.internationalDelivery,
    //
    required this.sizeChartUrl,
    required this.fileUrls,
    required this.hasDiscount,
    required this.discounts,
    required this.sizeColors,
    //
    required this.year,
    required this.doors,
    required this.seats,
    required this.mileage,
    required this.make,
    required this.model,
    required this.brand,
    required this.bodyType,
    required this.emission,
    required this.fuelType,
    required this.engineSize,
    required this.mileageUnit,
    required this.transmission,
    required this.interiorColor,
    required this.exteriorColor,
    required this.vehiclesCategory,
    required this.meetUpLocation,
    required this.availability,
    //
    required this.age,
    required this.breed,
    required this.healthChecked,
    required this.petsCategory,
    required this.readyToLeave,
    required this.wormAndFleaTreated,
    required this.vaccinationUpToDate,
    //
    required this.isActive,
    required this.createdBy,
    required this.createdAt,
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
  @HiveField(9)
  final String address;
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
  //
  @HiveField(30)
  final double currentLongitude;
  @HiveField(31)
  final double currentLatitude;
  @HiveField(32)
  final double? collectionLatitude;
  @HiveField(33)
  final double? collectionLongitude;
  @HiveField(34)
  final LocationEntity? collectionLocation;
  //
  @HiveField(40)
  final int? localDelivery;
  @HiveField(41)
  final int? internationalDelivery;
  // 50
  //
  @HiveField(60)
  final AttachmentEntity? sizeChartUrl;
  @HiveField(61)
  final List<AttachmentEntity> fileUrls;
  //
  @HiveField(70)
  final bool hasDiscount;
  @HiveField(71)
  final List<SizeColorEntity> sizeColors;
  @HiveField(72)
  final List<DiscountEntity> discounts;
  //
  @HiveField(80)
  final int? year;
  @HiveField(81)
  final int? doors;
  @HiveField(82)
  final int? seats;
  @HiveField(83)
  final int? mileage;
  @HiveField(84)
  final String? make;
  @HiveField(85)
  final String? model;
  @HiveField(86)
  final String? brand;
  @HiveField(87)
  final String? bodyType;
  @HiveField(88)
  final String? emission;
  @HiveField(89)
  final String? fuelType;
  @HiveField(90)
  final double? engineSize;
  @HiveField(91)
  final String? mileageUnit;
  @HiveField(92)
  final String? transmission;
  @HiveField(93)
  final String? interiorColor;
  @HiveField(94)
  final String? exteriorColor;
  @HiveField(95)
  final String? vehiclesCategory;
  @HiveField(96)
  final LocationEntity? meetUpLocation;
  @HiveField(97)
  final List<AvailabilityEntity>? availability;
  //
  @HiveField(110)
  final String? age;
  @HiveField(111)
  final String? breed;
  @HiveField(112)
  final bool? healthChecked;
  @HiveField(113)
  final String? petsCategory;
  @HiveField(114)
  final String? readyToLeave;
  @HiveField(115)
  final bool? wormAndFleaTreated;
  @HiveField(116)
  final bool? vaccinationUpToDate;
  //
  @HiveField(190)
  final bool isActive;
  @HiveField(191)
  final String createdBy;
  @HiveField(192)
  final DateTime createdAt;
  @HiveField(193)
  final String? accessCode;
  @HiveField(199)
  final DateTime inHiveAt;

  String get imageURL => fileUrls.isEmpty ? '' : fileUrls.first.url;
  String get priceStr => '$currency $price'.toUpperCase();

  double get discountedPrice {
    if (hasDiscount) {
      if (discounts.isEmpty) return price;
      final DiscountEntity dis = discounts.last;
      return price - (price * dis.discount / 100);
    }
    return price;
  }
}
