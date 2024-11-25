import 'package:hive/hive.dart';

import '../../../../../core/enums/routine/day_type.dart';
part 'routine_entity.g.dart';

@HiveType(typeId: 42)
class RoutineEntity {
  RoutineEntity({
    required this.day,
    required this.isOpen,
    this.closing,
    this.opening,
  });

  @HiveField(0)
  final DayType day;
  @HiveField(1)
  final bool isOpen;
  @HiveField(2)
  final String? closing;
  @HiveField(3)
  final String? opening;
}
