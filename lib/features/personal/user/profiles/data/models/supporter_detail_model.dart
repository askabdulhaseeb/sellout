import '../../../../../../core/enums/core/status_type.dart';
import '../../../../../../core/extension/string_ext.dart';
import '../../domain/entities/supporter_detail_entity.dart';

class SupporterDetailModel extends SupporterDetailEntity {
  SupporterDetailModel({
    required super.userID,
    required super.supportingTime,
    required super.status,
  });

  factory SupporterDetailModel.fromMap(Map<String, dynamic> map) {
    return SupporterDetailModel(
      userID: map['user_id'] ?? '',
      supportingTime:
          map['supporting_time']?.toString().toDateTime() ?? DateTime.now(),
      status: StatusType.fromJson(map['status']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userID,
      'supporting_time': supportingTime.toIso8601String(),
      'status': status.json,
    };
  }
}
