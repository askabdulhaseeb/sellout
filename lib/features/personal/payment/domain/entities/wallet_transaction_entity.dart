class WalletTransactionEntity {
  const WalletTransactionEntity({
    required this.id,
    required this.amount,
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
  final double amount;
  final String currency;
  final String status;
  final String type;
  final String createdAt;
  final String stripeTransferId;
  final String stripePayoutId;
  final String paidAt;
  final String payoutType;
}
