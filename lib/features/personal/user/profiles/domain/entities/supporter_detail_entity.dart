import 'package:hive/hive.dart';

import '../../../../../../core/enums/core/status_type.dart';
part 'supporter_detail_entity.g.dart';

@HiveType(typeId: 36)
class SupporterDetailEntity {
  SupporterDetailEntity({
    required this.userID,
    required this.supportingTime,
    required this.status,
  });

  @HiveField(0)
  final String userID;
  @HiveField(1)
  final DateTime supportingTime;
  @HiveField(2)
  final StatusType status;
}
