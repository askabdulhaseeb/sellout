import '../../domain/entities/wallet_funds_in_hold_entity.dart';

class WalletFundsInHoldModel extends WalletFundsInHoldEntity {
  const WalletFundsInHoldModel({
    required super.transactionId,
    required super.amount,
    required super.postId,
    required super.releaseAt,
    required super.fundId,
    required super.currency,
    required super.orderId,
    required super.status,
  });

  factory WalletFundsInHoldModel.fromJson(Map<String, dynamic> json) {
    return WalletFundsInHoldModel(
      transactionId: (json['transaction_id'] ?? '').toString(),
      amount: (json['amount'] ?? 0).toDouble(),
      postId: (json['post_id'] ?? '').toString(),
      releaseAt: (json['release_at'] ?? '').toString(),
      fundId: (json['fund_id'] ?? '').toString(),
      currency: (json['currency'] ?? '').toString(),
      orderId: (json['order_id'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
    );
  }
}
