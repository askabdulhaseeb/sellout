import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../../core/enums/core/status_type.dart';
part 'user_support_info_entity.g.dart';

@HiveType(typeId: 45)
class UserSupportInfoEntity {
  UserSupportInfoEntity({
    required this.userID,
    required this.supportDate,
    required this.status,
  });

  @HiveField(0)
  final String userID;
  @HiveField(1)
  final DateTime supportDate;
  @HiveField(2)
  final StatusType status;
}
