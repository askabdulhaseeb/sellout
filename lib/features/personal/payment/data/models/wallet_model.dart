import 'dart:convert';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/entities/wallet_funds_in_hold_entity.dart';
import '../../domain/entities/wallet_transaction_entity.dart';
import 'amount_in_connected_account_model.dart';
import 'wallet_funds_in_hold_model.dart';
import 'wallet_transaction_model.dart';

class WalletModel extends WalletEntity {

   WalletModel({
    required super.withdrawableBalance,
    required super.nextReleaseAt,
    required super.currency,
    required super.createdAt,
    required super.canReceive,
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
    required super.canWithdraw,
    required super.walletId,
    required super.amountInConnectedAccount,
  });
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'withdrawable_balance': withdrawableBalance,
      'next_release_at': nextReleaseAt,
      'currency': currency,
      'created_at': createdAt,
      'can_receive': canReceive,
      'status': status,
      'total_earnings': totalEarnings,
      'transaction_history': transactionHistory
          .map((WalletTransactionEntity e) => (e as dynamic).toJson())
          .toList(),
      'pending_balance': pendingBalance,
      'total_balance': totalBalance,
      'updated_at': updatedAt,
      'entity_id': entityId,
      'total_refunded': totalRefunded,
      'funds_in_hold': fundsInHold
          .map((WalletFundsInHoldEntity e) => (e as dynamic).toJson())
          .toList(),
      'total_withdrawn': totalWithdrawn,
      'can_withdraw': canWithdraw,
      'wallet_id': walletId,
      'amount_in_connected_account': amountInConnectedAccount != null
          ? (amountInConnectedAccount as dynamic).toJson()
          : null,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  static WalletModel fromJsonString(String jsonString) {
    return WalletModel.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> transactionHistoryRaw =
        (json['transaction_history'] as List<dynamic>?) ?? <dynamic>[];
    final List<dynamic> fundsInHoldRaw =
        (json['funds_in_hold'] as List<dynamic>?) ?? <dynamic>[];
    final Map<String, dynamic>? amountInConnectedAccountRaw =
        json['amount_in_connected_account'] as Map<String, dynamic>?;

    return WalletModel(
      withdrawableBalance: (json['withdrawable_balance'] ?? 0).toDouble(),
      nextReleaseAt: json['next_release_at'] ?? '',
      currency: json['currency'] ?? '',
      createdAt: json['created_at'] ?? '',
      canReceive: json['can_receive'] ?? false,
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
      canWithdraw: json['can_withdraw'] ?? false,
      walletId: json['wallet_id'] ?? '',
      amountInConnectedAccount: amountInConnectedAccountRaw != null
          ? AmountInConnectedAccountModel.fromJson(amountInConnectedAccountRaw)
          : null,
    );
  }
}
