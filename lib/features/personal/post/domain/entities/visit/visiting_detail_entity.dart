import 'package:hive/hive.dart';

import 'visiting_detail_post_entity.dart';

part 'visiting_detail_entity.g.dart';

@HiveType(typeId: 14)
class VisitingDetailEntity {
  const VisitingDetailEntity({
    required this.visitingId,
    required this.post,
    required this.dateTime,
    required this.visiterId,
    required this.visitingTime,
    required this.hostId,
    required this.status,
  });

  @HiveField(0)
  final String visitingId;
  @HiveField(1)
  final VisitingDetailPostEntity post;
  @HiveField(2)
  final DateTime dateTime;
  @HiveField(3)
  final String visiterId;
  @HiveField(4)
  final String visitingTime;
  @HiveField(5)
  final String hostId;
  @HiveField(6)
  final String status;
}
