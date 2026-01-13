import 'dart:convert';
import '../../domain/entities/amount_in_connected_account_entity.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/entities/wallet_funds_in_hold_entity.dart';
import '../../domain/entities/wallet_transaction_entity.dart';
import 'amount_in_connected_account_model.dart';
import 'wallet_funds_in_hold_model.dart';
import 'wallet_transaction_model.dart';

class WalletModel extends WalletEntity {

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    // Handle transaction_history - socket.io may send various List/Map types
    final dynamic transactionHistoryRaw = json['transaction_history'];
    final List<WalletTransactionEntity> transactionHistory = <WalletTransactionEntity>[];
    if (transactionHistoryRaw is List) {
      for (final dynamic item in transactionHistoryRaw) {
        if (item is Map) {
          transactionHistory.add(
            WalletTransactionModel.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }

    // Handle funds_in_hold - socket.io may send various List/Map types
    final dynamic fundsInHoldRaw = json['funds_in_hold'];
    final List<WalletFundsInHoldEntity> fundsInHold = <WalletFundsInHoldEntity>[];
    if (fundsInHoldRaw is List) {
      for (final dynamic item in fundsInHoldRaw) {
        if (item is Map) {
          fundsInHold.add(
            WalletFundsInHoldModel.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }

    // Handle amount_in_connected_account - socket.io may send various Map types
    final dynamic amountInConnectedAccountRaw = json['amount_in_connected_account'];
    AmountInConnectedAccountModel? amountInConnectedAccount;
    if (amountInConnectedAccountRaw is Map) {
      amountInConnectedAccount = AmountInConnectedAccountModel.fromJson(
        Map<String, dynamic>.from(amountInConnectedAccountRaw),
      );
    }

    // Get currency - fallback to amount_in_connected_account.currency if top-level is missing
    String currency = (json['currency'] ?? '').toString();
    if (currency.isEmpty && amountInConnectedAccount != null) {
      currency = amountInConnectedAccount.currency;
    }

    return WalletModel(
      withdrawableBalance: (json['withdrawable_balance'] ?? 0).toDouble(),
      nextReleaseAt: (json['next_release_at'] ?? '').toString(),
      currency: currency.toUpperCase(),
      createdAt: (json['created_at'] ?? '').toString(),
      canReceive: json['can_receive'] == true,
      status: (json['status'] ?? '').toString(),
      totalEarnings: (json['total_earnings'] ?? 0).toDouble(),
      transactionHistory: transactionHistory,
      pendingBalance: (json['pending_balance'] ?? 0).toDouble(),
      totalBalance: (json['total_balance'] ?? 0).toDouble(),
      updatedAt: (json['updated_at'] ?? '').toString(),
      entityId: (json['entity_id'] ?? '').toString(),
      totalRefunded: (json['total_refunded'] ?? 0).toDouble(),
      fundsInHold: fundsInHold,
      totalWithdrawn: (json['total_withdrawn'] ?? 0).toDouble(),
      canWithdraw: json['can_withdraw'] == true,
      walletId: (json['wallet_id'] ?? '').toString(),
      amountInConnectedAccount: amountInConnectedAccount,
    );
  }
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

  @override
  WalletModel copyWith({
    double? withdrawableBalance,
    String? nextReleaseAt,
    String? currency,
    String? createdAt,
    bool? canReceive,
    String? status,
    double? totalEarnings,
    List<WalletTransactionEntity>? transactionHistory,
    double? pendingBalance,
    double? totalBalance,
    String? updatedAt,
    String? entityId,
    double? totalRefunded,
    List<WalletFundsInHoldEntity>? fundsInHold,
    double? totalWithdrawn,
    bool? canWithdraw,
    String? walletId,
    AmountInConnectedAccountEntity? amountInConnectedAccount,
  }) {
    return WalletModel(
      withdrawableBalance: withdrawableBalance ?? this.withdrawableBalance,
      nextReleaseAt: nextReleaseAt ?? this.nextReleaseAt,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      canReceive: canReceive ?? this.canReceive,
      status: status ?? this.status,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      transactionHistory: transactionHistory ?? this.transactionHistory,
      pendingBalance: pendingBalance ?? this.pendingBalance,
      totalBalance: totalBalance ?? this.totalBalance,
      updatedAt: updatedAt ?? this.updatedAt,
      entityId: entityId ?? this.entityId,
      totalRefunded: totalRefunded ?? this.totalRefunded,
      fundsInHold: fundsInHold ?? this.fundsInHold,
      totalWithdrawn: totalWithdrawn ?? this.totalWithdrawn,
      canWithdraw: canWithdraw ?? this.canWithdraw,
      walletId: walletId ?? this.walletId,
      amountInConnectedAccount:
          amountInConnectedAccount ?? this.amountInConnectedAccount,
    );
  }
}
