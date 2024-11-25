import '../../domain/entity/business_travel_detail_entity.dart';

class BusinessTravelDetailModel extends BusinessTravelDetailEntity {
  BusinessTravelDetailModel({
    required super.currency,
    required super.maxTravelTime,
    required super.timeType,
    required super.maxTravel,
    required super.travelFee,
    required super.distance,
  });

  factory BusinessTravelDetailModel.fromJson(Map<String, dynamic> json) =>
      BusinessTravelDetailModel(
        currency: json['currency'],
        maxTravelTime: json['max_travel_time'],
        timeType: json['time_type'],
        maxTravel: json['max_travel'],
        travelFee:
            double.tryParse(json['travel_fee']?.toString() ?? '0.0') ?? 0.0,
        distance: json['distance'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'currency': currency,
        'max_travel_time': maxTravelTime,
        'time_type': timeType,
        'max_travel': maxTravel,
        'travel_fee': travelFee,
        'distance': distance,
      };
}
