import 'package:hive/hive.dart';
part 'login_detail_entity.g.dart';
@HiveType(typeId: 52)
class LoginDetailEntity {
  LoginDetailEntity({
    required this.type,
    required this.role,
  });
  @HiveField(0)
  final String type; // business , user,...
  @HiveField(1)
  final String role; // founder , employee,...
}
