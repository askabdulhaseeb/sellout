import 'package:hive/hive.dart';
part 'time_away_entity.g.dart';

@HiveType(typeId: 64)
class TimeAwayEntity {
  const TimeAwayEntity({
    @HiveField(0) this.startDate,
    @HiveField(1) this.endDate,
    @HiveField(2) this.message,
  });

  @HiveField(0)
  final String? startDate;

  @HiveField(1)
  final String? endDate;

  @HiveField(2)
  final String? message;

  TimeAwayEntity copyWith({
    String? startDate,
    String? endDate,
    String? message,
  }) {
    return TimeAwayEntity(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      message: message ?? this.message,
    );
  }
}
