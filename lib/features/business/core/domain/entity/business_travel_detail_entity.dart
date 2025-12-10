import 'package:hive_ce_flutter/hive_flutter.dart';

part 'business_travel_detail_entity.g.dart';

@HiveType(typeId: 40)
class BusinessTravelDetailEntity {
  BusinessTravelDetailEntity({
    required this.currency,
    required this.maxTravelTime,
    required this.timeType,
    required this.maxTravel,
    required this.travelFee,
    required this.distance,
  });

  @HiveField(0)
  final String? currency;
  @HiveField(1)
  final int? maxTravelTime;
  @HiveField(2)
  final String? timeType;
  @HiveField(3)
  final int? maxTravel;
  @HiveField(4)
  final double? travelFee;
  @HiveField(5)
  final String? distance;
}
