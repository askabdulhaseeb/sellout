import '../../domain/entities/wallet_transaction_entity.dart';

class WalletTransactionModel extends WalletTransactionEntity {
  const WalletTransactionModel({
    required super.id,
    required super.transferAmount,
    required super.payoutAmount,
    required super.currency,
    required super.status,
    required super.type,
    required super.createdAt,
    required super.stripeTransferId,
    required super.stripePayoutId,
    required super.paidAt,
    required super.payoutType,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: (json['id'] ?? '').toString(),
      transferAmount: (json['transfer_amount'] ?? 0).toDouble(),
      payoutAmount: (json['payout_amount'] ?? 0).toDouble(),
      currency: (json['currency'] ?? '').toString().toUpperCase(),
      status: (json['status'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      createdAt: (json['created_at'] ?? '').toString(),
      stripeTransferId: (json['stripe_transfer_id'] ?? '').toString(),
      stripePayoutId: (json['stripe_payout_id'] ?? '').toString(),
      paidAt: (json['paid_at'] ?? '').toString(),
      payoutType: (json['payout_type'] ?? '').toString(),
    );
  }
}
