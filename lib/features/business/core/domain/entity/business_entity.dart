import 'package:hive/hive.dart';

import '../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../personal/location/domain/entities/location_entity.dart';
import 'business_address_entity.dart';
import 'business_employee_entity.dart';
import 'business_travel_detail_entity.dart';
import 'routine_entity.dart';

part 'business_entity.g.dart';

@HiveType(typeId: 39)
class BusinessEntity {
  BusinessEntity({
    required this.businessID,
    required this.location,
    required this.acceptPromotions,
    required this.locationType,
    required this.travelDetail,
    required this.employees,
    required this.address,
    required this.displayName,
    required this.ownerID,
    required this.tagline,
    required this.phoneNumber,
    required this.companyNo,
    required this.routine,
    required this.listOfReviews,
    required this.createdAt,
    required this.updatedAt,
    required this.logo,
  });

  @HiveField(0)
  final String businessID;
  @HiveField(1)
  final LocationEntity location;
  @HiveField(2)
  final bool acceptPromotions;
  @HiveField(3)
  final String locationType;
  @HiveField(4)
  final BusinessTravelDetailEntity travelDetail;
  @HiveField(5)
  final List<BusinessEmployeeEntity> employees;
  @HiveField(6)
  final BusinessAddressEntity address;
  @HiveField(7)
  final String displayName;
  @HiveField(8)
  final String ownerID;
  @HiveField(9)
  final String tagline;
  @HiveField(10)
  final String phoneNumber;
  @HiveField(11)
  final String companyNo;
  @HiveField(12)
  final List<RoutineEntity> routine;
  @HiveField(13)
  final List<double> listOfReviews;
  @HiveField(14)
  final DateTime createdAt;
  @HiveField(15)
  final DateTime updatedAt;
  @HiveField(16)
  final AttachmentEntity? logo;
}
