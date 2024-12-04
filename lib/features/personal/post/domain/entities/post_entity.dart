import 'package:hive/hive.dart';

import '../../../../../core/enums/listing/core/boolean_status_type.dart';
import '../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../location/domain/entities/location_entity.dart';
import 'meetup/availability_entity.dart';
import 'size_color/discount_entity.dart';
import 'size_color/size_color_entity.dart';
part 'post_entity.g.dart';

@HiveType(typeId: 20)
class PostEntity {
  const PostEntity({
    required this.quantity,
    required this.address,
    required this.isActive,
    required this.listId,
    required this.currentLongitude,
    required this.createdAt,
    required this.discount,
    required this.description,
    required this.fileUrls,
    required this.title,
    required this.type,
    required this.createdBy,
    required this.acceptOffers,
    required this.sizeColors,
    required this.currentLatitude,
    required this.postId,
    required this.deliveryType,
    required this.price,
    required this.minOfferAmount,
    required this.condition,
    required this.sizeChartUrl,
    required this.currency,
    required this.privacy,
    required this.brand,
    required this.collectionLatitude,
    required this.collectionLongitude,
    this.collectionLocation,
    this.localDelivery,
    this.internationalDelivery,
    this.fuelType,
    this.doors,
    this.availability,
    this.emission,
    this.exteriorColor,
    this.seats,
    this.vehiclesCategory,
    this.meetUpLocation,
    this.interiorColor,
    this.transmission,
    this.mileage,
    this.model,
    this.engineSize,
    this.make,
    this.bodyType,
    this.mileageUnit,
    this.year,
    this.petsCategory,
    this.healthChecked,
    this.breed,
    this.age,
    this.vaccinationUpToDate,
    this.readyToLeave,
    this.wormAndFleaTreated,
    this.accessCode,
    this.businessID,
  });

  @HiveField(0)
  final int quantity;
  @HiveField(1)
  final String address;
  @HiveField(2)
  final bool isActive;
  @HiveField(3)
  final String listId;
  @HiveField(4)
  final double currentLongitude;
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final DiscountEntity? discount;
  @HiveField(7)
  final String description;
  @HiveField(8)
  final List<AttachmentEntity> fileUrls;
  @HiveField(9)
  final String title;
  @HiveField(10)
  final ListingType type;
  @HiveField(11)
  final String createdBy;
  @HiveField(12)
  final BooleanStatusType acceptOffers;
  @HiveField(13)
  final List<SizeColorEntity> sizeColors;
  @HiveField(14)
  final double currentLatitude;
  @HiveField(15)
  final String postId;
  @HiveField(16)
  final DeliveryType deliveryType;
  @HiveField(17)
  final double price;
  @HiveField(18)
  final double minOfferAmount;
  @HiveField(19)
  final ConditionType condition;
  @HiveField(20)
  final AttachmentEntity? sizeChartUrl;
  @HiveField(21)
  final String? currency;
  @HiveField(22)
  final PrivacyType privacy;
  @HiveField(23)
  final String? brand;
  @HiveField(24)
  final double? collectionLatitude;
  @HiveField(25)
  final double? collectionLongitude;
  @HiveField(26)
  final LocationEntity? collectionLocation;
  @HiveField(27)
  final int? localDelivery;
  @HiveField(28)
  final int? internationalDelivery;
  @HiveField(29)
  final String? fuelType;
  @HiveField(30)
  final int? doors;
  @HiveField(31)
  final List<AvailabilityEntity>? availability;
  @HiveField(32)
  final String? emission;
  @HiveField(33)
  final String? exteriorColor;
  @HiveField(34)
  final int? seats;
  @HiveField(35)
  final String? vehiclesCategory;
  @HiveField(36)
  final LocationEntity? meetUpLocation;
  @HiveField(37)
  final String? interiorColor;
  @HiveField(38)
  final String? transmission;
  @HiveField(39)
  final int? mileage;
  @HiveField(40)
  final String? model;
  @HiveField(41)
  final double? engineSize;
  @HiveField(42)
  final String? make;
  @HiveField(43)
  final String? bodyType;
  @HiveField(44)
  final String? mileageUnit;
  @HiveField(45)
  final int? year;
  @HiveField(46)
  final String? petsCategory;
  @HiveField(47)
  final BooleanStatusType? healthChecked;
  @HiveField(48)
  final String? breed;
  @HiveField(49)
  final String? age;
  @HiveField(50)
  final BooleanStatusType? vaccinationUpToDate;
  @HiveField(51)
  final String? readyToLeave;
  @HiveField(52)
  final BooleanStatusType? wormAndFleaTreated;
  @HiveField(53)
  final String? accessCode;
  @HiveField(54)
  final String? businessID;

  String get imageURL => fileUrls.isEmpty ? '' : fileUrls.first.url;
  String get priceStr => '$currency $price'.toUpperCase();
}
