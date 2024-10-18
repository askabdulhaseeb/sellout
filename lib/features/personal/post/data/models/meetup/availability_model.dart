import '../../../domain/entities/meetup/availability_entity.dart';

class AvailabilityModel extends AvailabilityEntity {
  AvailabilityModel({
    required super.day,
    required super.isOpen,
    String? closingTime,
    String? openingTime,
  }) : super(
          closingTime: closingTime ?? '',
          openingTime: openingTime ?? '',
        );

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) =>
      AvailabilityModel(
        day: json['day'],
        isOpen: json['is_open'],
        closingTime: json['closing_time'] ?? '',
        openingTime: json['opening_time'] ?? '',
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'day': day,
        'is_open': isOpen,
        'closing_time': closingTime,
        'opening_time': openingTime,
      };
}
