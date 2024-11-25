import 'package:hive/hive.dart';
part 'business_employee_entity.g.dart';

@HiveType(typeId: 41)
class BusinessEmployeeEntity {
  BusinessEmployeeEntity({
    required this.uid,
    required this.role,
    required this.addBy,
    required this.joinAt,
    required this.chatAt,
    this.source,
    this.status,
  });

  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String role;
  @HiveField(2)
  final String? addBy;
  @HiveField(3)
  final DateTime joinAt;
  @HiveField(4)
  final String? source;
  @HiveField(5)
  final DateTime chatAt;
  @HiveField(6)
  final String? status;
}
