import 'package:hive_ce/hive.dart';
part 'fast_delivery_entity.g.dart';

@HiveType(typeId: 102)
class FastDeliveryEntity {
  @HiveField(0)
  final bool? available;
  @HiveField(1)
  final String? message;
  @HiveField(2)
  final bool? requested;

  const FastDeliveryEntity({this.available, this.message, this.requested});
}
