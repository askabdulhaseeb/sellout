import '../../../../../../core/enums/core/status_type.dart';
import '../../../../../../core/extension/string_ext.dart';
import '../../domain/entities/user_support_info_entity.dart';

class UserSupportInfoModel extends UserSupportInfoEntity {
  UserSupportInfoModel({
    required super.userID,
    required super.supportDate,
    required super.status,
  });

  factory UserSupportInfoModel.fromMap(Map<String, dynamic> map) {
    return UserSupportInfoModel(
      userID: map['user_id'] ?? '',
      supportDate:
          map['supporting_time']?.toString().toDateTime() ?? DateTime.now(),
      status: StatusType.fromJson(map['status']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userID,
      'supporting_time': supportDate.millisecondsSinceEpoch,
      'status': status.json,
    };
  }
}
