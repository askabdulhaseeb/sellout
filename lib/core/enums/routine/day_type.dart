import 'package:hive/hive.dart';

part 'day_type.g.dart';

@HiveType(typeId: 32)
enum DayType {
  @HiveField(0)
  monday('monday', 'monday'),
  @HiveField(1)
  tuesday('tuesday', 'tuesday'),
  @HiveField(2)
  wednesday('wednesday', 'wednesday'),
  @HiveField(3)
  thursday('thursday', 'thursday'),
  @HiveField(4)
  friday('friday', 'friday'),
  @HiveField(5)
  saturday('saturday', 'saturday'),
  @HiveField(6)
  sunday('sunday', 'sunday');

  const DayType(this.code, this.json);
  final String code;
  final String json;

  static DayType fromString(String? value) => value == null
      ? DayType.sunday
      : DayType.values.firstWhere(
          (DayType e) => e.code == value,
          orElse: () => DayType.sunday,
        );
}
