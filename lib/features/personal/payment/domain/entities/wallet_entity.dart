abstract class WalletEntity {

  const WalletEntity({
    required this.withdrawableBalance,
    required this.nextReleaseAt,
    required this.currency,
    required this.createdAt,
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
    required this.walletId,
  });
  final double withdrawableBalance;
  final String nextReleaseAt;
  final String currency;
  final String createdAt;
  final String status;
  final double totalEarnings;
  final List<dynamic> transactionHistory;
  final double pendingBalance;
  final double totalBalance;
  final String updatedAt;
  final String entityId;
  final double totalRefunded;
  final List<dynamic> fundsInHold;
  final double totalWithdrawn;
  final String walletId;
}
