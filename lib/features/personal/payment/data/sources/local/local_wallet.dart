import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/adapters.dart';
import '../../../domain/entities/wallet_entity.dart';
import '../../../domain/entities/wallet_transaction_entity.dart';
import '../../../domain/entities/amount_in_connected_account_entity.dart';
import '../../models/wallet_model.dart';
import '../../models/wallet_transaction_model.dart';
import '../../models/amount_in_connected_account_model.dart';
import '../../../../../../core/sources/local/local_hive_box.dart';
import '../../../../../../core/utilities/app_string.dart';

class LocalWallet extends LocalHiveBox<WalletEntity> {
  @override
  String get boxName => AppStrings.localWalletBox;

  @override
  bool get requiresEncryption => true;

  Box<WalletEntity> get _box => box;

  /// Notifier that emits when wallet data changes.
  /// Uses a counter to ensure listeners are always notified, even for same wallet.
  static final ValueNotifier<int> walletUpdatedNotifier = ValueNotifier<int>(0);

  /// Save wallet to local storage and notify listeners.
  Future<void> saveWallet(WalletEntity wallet) async {
    await _box.put(AppStrings.localWalletBox, wallet);
    // Increment counter to always trigger listeners
    walletUpdatedNotifier.value = walletUpdatedNotifier.value + 1;
    debugPrint('💾 LocalWallet.saveWallet: Saved and notified listeners (count: ${walletUpdatedNotifier.value})');
  }

  /// Get wallet from local storage.
  WalletEntity? getWallet() => _box.get(AppStrings.localWalletBox);

  /// Clear wallet from local storage.
  Future<void> clearWallet() async {
    await _box.delete(AppStrings.localWalletBox);
    // Increment counter to notify listeners of change
    walletUpdatedNotifier.value = walletUpdatedNotifier.value + 1;
  }

  /// Handle wallet-updated socket event.
  /// Merges socket data with existing wallet to preserve fields not in the event.
  /// Socket event only contains: wallet_id, withdrawable_balance, transaction_history, amount_in_connected_account
  Future<void> handleWalletUpdatedEvent(dynamic data) async {
    if (data == null) return;
    try {
      final Map<String, dynamic> map = _parseToMap(data);
      if (map.isEmpty) return;

      final WalletEntity? existingWallet = getWallet();

      if (existingWallet != null) {
        // Merge socket data with existing wallet to preserve fields not in socket event
        final WalletEntity updatedWallet = _mergeWalletData(existingWallet, map);
        await saveWallet(updatedWallet);
      } else {
        // No existing wallet, create from socket data (some fields may be 0)
        final WalletModel wallet = WalletModel.fromJson(map);
        await saveWallet(wallet);
      }
    } catch (e) {
      debugPrint('Error handling wallet-updated event: $e');
    }
  }

  /// Merge socket event data with existing wallet.
  /// Only updates fields that are present in the socket data.
  WalletEntity _mergeWalletData(WalletEntity existing, Map<String, dynamic> socketData) {
    // Parse amount_in_connected_account if present
    AmountInConnectedAccountEntity? amountInConnectedAccount;
    if (socketData.containsKey('amount_in_connected_account')) {
      final dynamic amountData = socketData['amount_in_connected_account'];
      if (amountData is Map) {
        amountInConnectedAccount = AmountInConnectedAccountModel.fromJson(
          Map<String, dynamic>.from(amountData),
        );
      }
    }

    // Parse transaction_history if present
    List<WalletTransactionEntity>? transactionHistory;
    if (socketData.containsKey('transaction_history')) {
      final dynamic historyData = socketData['transaction_history'];
      if (historyData is List) {
        transactionHistory = <WalletTransactionEntity>[];
        for (final dynamic item in historyData) {
          if (item is Map) {
            transactionHistory.add(
              WalletTransactionModel.fromJson(Map<String, dynamic>.from(item)),
            );
          }
        }
      }
    }

    return existing.copyWith(
      withdrawableBalance: socketData.containsKey('withdrawable_balance')
          ? (socketData['withdrawable_balance'] ?? 0).toDouble()
          : null,
      walletId: socketData.containsKey('wallet_id')
          ? (socketData['wallet_id'] ?? '').toString()
          : null,
      transactionHistory: transactionHistory,
      amountInConnectedAccount: amountInConnectedAccount,
    );
  }

  /// Handle payout-status-updated socket event.
  /// Updates only the amount_in_connected_account field.
  Future<void> handlePayoutStatusUpdatedEvent(dynamic data) async {
    if (data == null) return;
    try {
      final Map<String, dynamic> map = _parseToMap(data);
      if (map.isEmpty) return;

      final WalletEntity? existingWallet = getWallet();
      if (existingWallet == null) return;

      // Parse amount_in_connected_account if present
      AmountInConnectedAccountEntity? amountInConnectedAccount;
      if (map.containsKey('amount_in_connected_account')) {
        final dynamic amountData = map['amount_in_connected_account'];
        if (amountData is Map) {
          amountInConnectedAccount = AmountInConnectedAccountModel.fromJson(
            Map<String, dynamic>.from(amountData),
          );
        }
      }

      if (amountInConnectedAccount != null) {
        final WalletEntity updatedWallet = existingWallet.copyWith(
          amountInConnectedAccount: amountInConnectedAccount,
        );
        await saveWallet(updatedWallet);
      }
    } catch (e) {
      debugPrint('Error handling payout-status-updated event: $e');
    }
  }

  /// Parse dynamic data to Map<String, dynamic>.
  Map<String, dynamic> _parseToMap(dynamic data) {
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    } else if (data is String) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    debugPrint('_parseToMap: Unsupported type: ${data.runtimeType}');
    return <String, dynamic>{};
  }
}
