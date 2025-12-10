import 'package:hive_ce/hive.dart';

part 'day_type.g.dart';

@HiveType(typeId: 32)
enum DayType {
  @HiveField(0)
  monday('monday', 'monday', 1),
  @HiveField(1)
  tuesday('tuesday', 'tuesday', 2),
  @HiveField(2)
  wednesday('wednesday', 'wednesday', 3),
  @HiveField(3)
  thursday('thursday', 'thursday', 4),
  @HiveField(4)
  friday('friday', 'friday', 5),
  @HiveField(5)
  saturday('saturday', 'saturday', 6),
  @HiveField(6)
  sunday('sunday', 'sunday', 7);

  const DayType(this.code, this.json, this.weekday);
  final String code;
  final String json;
  final int weekday;

  static DayType fromString(String? value) => value == null
      ? DayType.sunday
      : DayType.values.firstWhere(
          (DayType e) => e.code == value,
          orElse: () => DayType.sunday,
        );
}
