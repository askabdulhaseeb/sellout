import '../../../../../core/enums/routine/day_type.dart';
import '../../domain/entity/routine_entity.dart';

class RoutineModel extends RoutineEntity {
  RoutineModel({
    required super.day,
    required super.isOpen,
    super.closing,
    super.opening,
  });

  factory RoutineModel.fromJson(Map<String, dynamic> json) => RoutineModel(
        day: DayType.fromString(json['day']),
        isOpen: json['is_open'],
        closing: json['closing_time'],
        opening: json['opening_time'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'day': day.json,
        'is_open': isOpen,
        'closing_time': closing,
        'opening_time': opening,
      };
}
