import 'package:hive_ce/hive.dart';

import 'amount_in_connected_account_entity.dart';
import 'wallet_funds_in_hold_entity.dart';
import 'wallet_transaction_entity.dart';

part 'wallet_entity.g.dart';

@HiveType(typeId: 92)
class WalletEntity {
  WalletEntity({
    required this.withdrawableBalance,
    required this.nextReleaseAt,
    required this.currency,
    required this.createdAt,
    required this.canReceive,
    required this.status,
    required this.totalEarnings,
    required this.transactionHistory,
    required this.pendingBalance,
    required this.totalBalance,
    required this.updatedAt,
    required this.entityId,
    required this.totalRefunded,
    required this.fundsInHold,
    required this.totalWithdrawn,
    required this.canWithdraw,
    required this.walletId,
    required this.amountInConnectedAccount,
  });

  @HiveField(0)
  double withdrawableBalance;
  @HiveField(1)
  String nextReleaseAt;
  @HiveField(2)
  String currency;
  @HiveField(3)
  String createdAt;
  @HiveField(4)
  bool canReceive;
  @HiveField(5)
  String status;
  @HiveField(6)
  double totalEarnings;
  @HiveField(7)
  List<WalletTransactionEntity> transactionHistory;
  @HiveField(8)
  double pendingBalance;
  @HiveField(9)
  double totalBalance;
  @HiveField(10)
  String updatedAt;
  @HiveField(11)
  String entityId;
  @HiveField(12)
  double totalRefunded;
  @HiveField(13)
  List<WalletFundsInHoldEntity> fundsInHold;
  @HiveField(14)
  double totalWithdrawn;
  @HiveField(15)
  bool canWithdraw;
  @HiveField(16)
  String walletId;
  @HiveField(17)
  AmountInConnectedAccountEntity? amountInConnectedAccount;
}
