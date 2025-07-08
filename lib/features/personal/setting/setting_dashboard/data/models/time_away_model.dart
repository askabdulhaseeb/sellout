import '../../domain/entities/time_away_entity.dart';

class TimeAwayModel extends TimeAwayEntity {
  const TimeAwayModel({
    required super.startDate,
    required super.endDate,
    required super.message,
  });

  factory TimeAwayModel.fromJson(Map<String, dynamic> json) {
    return TimeAwayModel(
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'start_date': startDate,
        'end_date': endDate,
        'message': message,
      };
}
