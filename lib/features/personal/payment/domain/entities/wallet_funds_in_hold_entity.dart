abstract class WalletFundsInHoldEntity {
  const WalletFundsInHoldEntity({
    required this.transactionId,
    required this.amount,
    required this.postId,
    required this.releaseAt,
    required this.fundId,
    required this.currency,
    required this.orderId,
    required this.status,
  });

  final String transactionId;
  final double amount;
  final String postId;
  final String releaseAt;
  final String fundId;
  final String currency;
  final String orderId;
  final String status;
}
