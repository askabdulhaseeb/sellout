import 'package:hive/hive.dart';

import '../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../meetup/availability_entity.dart';
import '../meetup/meetup_location_entity.dart';

part 'visiting_detail_post_entity.g.dart';

@HiveType(typeId: 15)
class VisitingDetailPostEntity {
  VisitingDetailPostEntity({
    required this.listId,
    required this.currentLongitude,
    required this.year,
    required this.vehiclesCategory,
    required this.createdAt,
    required this.description,
    required this.availability,
    required this.fileUrls,
    required this.title,
    required this.acceptOffers,
    required this.seats,
    required this.emission,
    required this.transmission,
    required this.price,
    required this.condition,
    required this.bodyType,
    required this.currency,
    required this.model,
    required this.privacy,
    required this.make,
    required this.mileage,
    required this.address,
    required this.isActive,
    required this.interiorColor,
    required this.createdBy,
    required this.doors,
    required this.currentLatitude,
    required this.mileageUnit,
    required this.postId,
    required this.exteriorColor,
    required this.meetUpLocation,
    required this.engineSize,
    this.fuelType,
    this.accessCode,
  });

  @HiveField(0)
  final String listId;
  @HiveField(1)
  final double currentLongitude;
  @HiveField(2)
  final int year;
  @HiveField(3)
  final String vehiclesCategory;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
  final String description;
  @HiveField(6)
  final List<AvailabilityEntity> availability;
  @HiveField(7)
  final List<AttachmentEntity> fileUrls;
  @HiveField(8)
  final String title;
  @HiveField(9)
  final String acceptOffers;
  @HiveField(10)
  final int seats;
  @HiveField(11)
  final String emission;
  @HiveField(12)
  final String transmission;
  @HiveField(13)
  final int price;
  @HiveField(14)
  final ConditionType condition;
  @HiveField(15)
  final String bodyType;
  @HiveField(16)
  final String currency;
  @HiveField(17)
  final String model;
  @HiveField(18)
  final PrivacyType privacy;
  @HiveField(19)
  final String? fuelType;
  @HiveField(20)
  final String make;
  @HiveField(21)
  final int mileage;
  @HiveField(22)
  final String address;
  @HiveField(23)
  final bool isActive;
  @HiveField(24)
  final String interiorColor;
  @HiveField(25)
  final String createdBy;
  @HiveField(26)
  final int doors;
  @HiveField(27)
  final double currentLatitude;
  @HiveField(28)
  final String mileageUnit;
  @HiveField(29)
  final String postId;
  @HiveField(30)
  final String exteriorColor;
  @HiveField(31)
  final MeetUpLocationEntity meetUpLocation;
  @HiveField(32)
  final double engineSize;
  @HiveField(33)
  final String? accessCode;
}
