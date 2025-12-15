import '../../domain/entities/wallet_entity.dart';
import 'wallet_funds_in_hold_model.dart';
import 'wallet_transaction_model.dart';

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
    final List<dynamic> transactionHistoryRaw =
        (json['transaction_history'] as List<dynamic>?) ?? <dynamic>[];
    final List<dynamic> fundsInHoldRaw =
        (json['funds_in_hold'] as List<dynamic>?) ?? <dynamic>[];

    return WalletModel(
      withdrawableBalance: (json['withdrawable_balance'] ?? 0).toDouble(),
      nextReleaseAt: json['next_release_at'] ?? '',
      currency: json['currency'] ?? '',
      createdAt: json['created_at'] ?? '',
      status: json['status'] ?? '',
      totalEarnings: (json['total_earnings'] ?? 0).toDouble(),
      transactionHistory: transactionHistoryRaw
          .whereType<Map<String, dynamic>>()
          .map(WalletTransactionModel.fromJson)
          .toList(),
      pendingBalance: (json['pending_balance'] ?? 0).toDouble(),
      totalBalance: (json['total_balance'] ?? 0).toDouble(),
      updatedAt: json['updated_at'] ?? '',
      entityId: json['entity_id'] ?? '',
      totalRefunded: (json['total_refunded'] ?? 0).toDouble(),
      fundsInHold: fundsInHoldRaw
          .whereType<Map<String, dynamic>>()
          .map(WalletFundsInHoldModel.fromJson)
          .toList(),
      totalWithdrawn: (json['total_withdrawn'] ?? 0).toDouble(),
      walletId: json['wallet_id'] ?? '',
    );
  }
}
