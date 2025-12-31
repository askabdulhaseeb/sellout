import 'package:hive_ce_flutter/hive_flutter.dart';
part 'amount_in_connected_account_entity.g.dart';

@HiveType(typeId: 95)
class AmountInConnectedAccountEntity extends HiveObject {
  AmountInConnectedAccountEntity({
    required this.available,
    required this.currency,
    required this.lastSynced,
    required this.pending,
  });

  @HiveField(0)
  double available;
  @HiveField(1)
  String currency;
  @HiveField(2)
  String lastSynced;
  @HiveField(3)
  double pending;
}
