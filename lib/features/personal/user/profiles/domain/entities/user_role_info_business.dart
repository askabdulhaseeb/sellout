import 'package:hive/hive.dart';
part 'user_role_info_business.g.dart';

@HiveType(typeId: 44)
class UserRoleInfoInBusinessEntity {
  UserRoleInfoInBusinessEntity({
    required this.businessID,
    required this.role,
    required this.addedAt,
    required this.status,
  });

  @HiveField(0)
  final String businessID;
  @HiveField(1)
  final String role;
  @HiveField(2)
  final DateTime addedAt;
  @HiveField(3)
  final String status;
}
