import 'amount_in_connected_account_entity.dart';
import 'wallet_funds_in_hold_entity.dart';
import 'wallet_transaction_entity.dart';

abstract class WalletEntity {
  const WalletEntity({
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
  final double withdrawableBalance;
  final String nextReleaseAt;
  final String currency;
  final String createdAt;
  final bool canReceive;
  final String status;
  final double totalEarnings;
  final List<WalletTransactionEntity> transactionHistory;
  final double pendingBalance;
  final double totalBalance;
  final String updatedAt;
  final String entityId;
  final double totalRefunded;
  final List<WalletFundsInHoldEntity> fundsInHold;
  final double totalWithdrawn;
  final bool canWithdraw;
  final String walletId;
  final AmountInConnectedAccountEntity? amountInConnectedAccount;
}
