class CreatePayoutParams {
  const CreatePayoutParams({
    required this.walletId,
    required this.amount,
    required this.currency,
  });

  final String walletId;
  final double amount;
  final String currency;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'wallet_id': walletId,
    'amount': amount,
    'currency': currency,
  };
}
