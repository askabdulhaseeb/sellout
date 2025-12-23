class WalletTransactionEntity {
  const WalletTransactionEntity({
    required this.id,
    required this.transferAmount,
    required this.payoutAmount,
    required this.currency,
    required this.status,
    required this.type,
    required this.createdAt,
    required this.stripeTransferId,
    required this.stripePayoutId,
    required this.paidAt,
    required this.payoutType,
  });

  final String id;
  final double transferAmount;
  final double payoutAmount;
  final String currency;
  final String status;
  final String type;
  final String createdAt;
  final String stripeTransferId;
  final String stripePayoutId;
  final String paidAt;
  final String payoutType;

  double get amount {
    if (type.toLowerCase() == 'payout-to-bank') {
      return payoutAmount;
    }
    return transferAmount;
  }
}
