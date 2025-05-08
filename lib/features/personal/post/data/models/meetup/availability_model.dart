import '../../../../../../core/enums/routine/day_type.dart';
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
        day: DayType.fromString(json['day']),
        isOpen: json['is_open'],
        closingTime: json['closing_time'] ?? '',
        openingTime: json['opening_time'] ?? '',
      );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'day': day.json,
        'is_open': isOpen,
        if (isOpen == true) 'closing_time': closingTime,
        if (isOpen == true) 'opening_time': openingTime,
      };
  @override
  AvailabilityModel copyWith({
    DayType? day,
    bool? isOpen,
    String? openingTime,
    String? closingTime,
  }) {
    return AvailabilityModel(
      day: day ?? this.day,
      isOpen: isOpen ?? this.isOpen,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
    );
  }
}
