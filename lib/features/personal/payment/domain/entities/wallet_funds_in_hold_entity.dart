import 'package:hive_ce/hive.dart';
part 'wallet_funds_in_hold_entity.g.dart';

@HiveType(typeId: 94)
class WalletFundsInHoldEntity {
  WalletFundsInHoldEntity({
    required this.transactionId,
    required this.amount,
    required this.postId,
    required this.releaseAt,
    required this.fundId,
    required this.currency,
    required this.orderId,
    required this.status,
  });

  @HiveField(0)
  String transactionId;
  @HiveField(1)
  double amount;
  @HiveField(2)
  String postId;
  @HiveField(3)
  String releaseAt;
  @HiveField(4)
  String fundId;
  @HiveField(5)
  String currency;
  @HiveField(6)
  String orderId;
  @HiveField(7)
  String status;
}
