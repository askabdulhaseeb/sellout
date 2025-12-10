import 'package:hive_ce/hive.dart';
part 'business_profile_detail_entity.g.dart';

@HiveType(typeId: 48)
class ProfileBusinessDetailEntity {
  ProfileBusinessDetailEntity({
    required this.businessID,
    required this.roleSTR,
    required this.statusSTR,
    required this.addedAt,
  });

  @HiveField(0)
  final String businessID;
  @HiveField(1)
  final String roleSTR;
  @HiveField(2)
  final String statusSTR;
  @HiveField(3)
  final DateTime addedAt;
}
