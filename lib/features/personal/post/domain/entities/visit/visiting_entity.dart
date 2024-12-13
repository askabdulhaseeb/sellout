import 'package:hive/hive.dart';

import '../../../../../../core/enums/core/status_type.dart';
part 'visiting_entity.g.dart';

@HiveType(typeId: 14)
class VisitingEntity {
  VisitingEntity({
    required this.visitingID,
    required this.visiterID,
    required this.businessID,
    required this.hostID,
    required this.postID,
    required this.status,
    required this.visitingTime,
    required this.dateTime,
    required this.createdAt,
  }) : inHiveAt = DateTime.now();

  @HiveField(0)
  final String visitingID;
  @HiveField(1)
  final String visiterID;
  @HiveField(2)
  final String? businessID;
  @HiveField(3)
  final String hostID;
  @HiveField(4)
  final String postID;
  @HiveField(5)
  final StatusType status;
  @HiveField(6)
  final String visitingTime;
  @HiveField(7)
  final DateTime dateTime;
  @HiveField(8)
  final DateTime? createdAt;
  @HiveField(9)
  final DateTime? inHiveAt;
}
