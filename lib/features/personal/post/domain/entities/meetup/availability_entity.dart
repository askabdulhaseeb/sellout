import 'package:hive/hive.dart';
import '../../../../../../core/enums/routine/day_type.dart';
part 'availability_entity.g.dart';

@HiveType(typeId: 16)
class AvailabilityEntity {
  const AvailabilityEntity({
    required this.day,
    required this.isOpen,
    required this.closingTime,
    required this.openingTime,
  });

  @HiveField(0)
  final DayType day;
  @HiveField(1)
  final bool isOpen;
  @HiveField(2)
  final String closingTime;
  @HiveField(3)
  final String openingTime;

  AvailabilityEntity copyWith({
    DayType? day,
    bool? isOpen,
    String? openingTime,
    String? closingTime,
  }) {
    return AvailabilityEntity(
      day: day ?? this.day,
      isOpen: isOpen ?? this.isOpen,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'day': day.toString(), // or use a custom way to serialize DayType
      'isOpen': isOpen,
      'openingTime': openingTime,
      'closingTime': closingTime,
    };
  }
}
