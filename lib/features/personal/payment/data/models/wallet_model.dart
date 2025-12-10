import '../../domain/entities/wallet_entity.dart';

class WalletModel extends WalletEntity {
  const WalletModel({
    required super.withdrawableBalance,
    required super.nextReleaseAt,
    required super.currency,
    required super.createdAt,
    required super.status,
    required super.totalEarnings,
    required super.transactionHistory,
    required super.pendingBalance,
    required super.totalBalance,
    required super.updatedAt,
    required super.entityId,
    required super.totalRefunded,
    required super.fundsInHold,
    required super.totalWithdrawn,
    required super.walletId,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      withdrawableBalance: (json['withdrawable_balance'] ?? 0).toDouble(),
      nextReleaseAt: json['next_release_at'] ?? '',
      currency: json['currency'] ?? '',
      createdAt: json['created_at'] ?? '',
      status: json['status'] ?? '',
      totalEarnings: (json['total_earnings'] ?? 0).toDouble(),
      transactionHistory: json['transaction_history'] ?? <dynamic>[],
      pendingBalance: (json['pending_balance'] ?? 0).toDouble(),
      totalBalance: (json['total_balance'] ?? 0).toDouble(),
      updatedAt: json['updated_at'] ?? '',
      entityId: json['entity_id'] ?? '',
      totalRefunded: (json['total_refunded'] ?? 0).toDouble(),
      fundsInHold: json['funds_in_hold'] ?? <dynamic>[],
      totalWithdrawn: (json['total_withdrawn'] ?? 0).toDouble(),
      walletId: json['wallet_id'] ?? '',
    );
  }
}
