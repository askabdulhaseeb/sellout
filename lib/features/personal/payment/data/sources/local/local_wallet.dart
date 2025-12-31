import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/adapters.dart';
import '../../../domain/entities/wallet_entity.dart';
import '../../models/wallet_model.dart';
import '../../../../../../core/sources/local/local_hive_box.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../models/wallet_funds_in_hold_model.dart';

class LocalWallet extends LocalHiveBox<WalletEntity> {
  @override
  String get boxName => AppStrings.localWalletBox;

  @override
  bool get requiresEncryption => true;

  Box<WalletEntity> get _box => box;

  /// Notifier that emits the walletId of the last updated wallet.
  static final ValueNotifier<String?> walletUpdatedNotifier =
      ValueNotifier<String?>(null);

  /// Save or update the wallet by id
  Future<void> saveWallet(WalletEntity wallet) async {
    await _box.put(wallet.walletId, wallet);
    // Notify listeners that this wallet was updated
    walletUpdatedNotifier.value = wallet.walletId;
  }

  /// Get wallet by id
  WalletEntity? getWallet(String walletId) => _box.get(walletId);

  /// Remove wallet by id
  Future<void> clearWallet(String walletId) async {
    await _box.delete(walletId);
    walletUpdatedNotifier.value = walletId;
  }

  /// Update wallet with a function that modifies the WalletEntity
  Future<void> updateWallet(
    String walletId,
    WalletEntity Function(WalletEntity) update,
  ) async {
    final WalletEntity? wallet = getWallet(walletId);
    if (wallet == null) return;
    final WalletEntity updated = update(wallet);
    await saveWallet(updated);
  }

  /// Get all wallets
  List<WalletEntity> getAllWallets() => _box.values.toList();

  /// Get transaction history for a wallet
  List<dynamic> getTransactionHistory(String walletId) {
    final WalletEntity? wallet = getWallet(walletId);
    return wallet?.transactionHistory ?? <dynamic>[];
  }

  /// Get funds in hold for a wallet
  List<dynamic> getFundsInHold(String walletId) {
    final WalletEntity? wallet = getWallet(walletId);
    return wallet?.fundsInHold ?? <dynamic>[];
  }

  // --- WalletFundsInHoldModel Hive DB functions ---
  String get fundsInHoldBoxName => '${AppStrings.localWalletBox}_funds_in_hold';

  Box<WalletFundsInHoldModel>? _fundsInHoldBox;

  Future<Box<WalletFundsInHoldModel>> getFundsInHoldBox() async {
    if (_fundsInHoldBox?.isOpen == true) return _fundsInHoldBox!;
    _fundsInHoldBox = await Hive.openBox<WalletFundsInHoldModel>(
      fundsInHoldBoxName,
    );
    return _fundsInHoldBox!;
  }

  Future<void> saveFundsInHold(WalletFundsInHoldModel model) async {
    final Box<WalletFundsInHoldModel> box = await getFundsInHoldBox();
    await box.put(model.fundId, model);
  }

  WalletFundsInHoldModel? getFundsInHoldById(String fundId) {
    final Box<WalletFundsInHoldModel>? box = _fundsInHoldBox;
    return box?.get(fundId);
  }

  List<WalletFundsInHoldModel> getAllFundsInHold() {
    final Box<WalletFundsInHoldModel>? box = _fundsInHoldBox;
    return box?.values.toList() ?? <WalletFundsInHoldModel>[];
  }

  Future<void> clearFundsInHold(String fundId) async {
    final Box<WalletFundsInHoldModel> box = await getFundsInHoldBox();
    await box.delete(fundId);
  }

  /// Parse incoming socket payload (Map or JSON string) and save the wallet.
  Future<void> saveWalletFromPayload(dynamic data) async {
    if (data == null) return;

    WalletModel? model;
    try {
      if (data is WalletModel) {
        model = data;
      } else if (data is Map<String, dynamic>) {
        model = WalletModel.fromJson(Map<String, dynamic>.from(data));
      } else if (data is String) {
        final Map<String, dynamic> parsed =
            jsonDecode(data) as Map<String, dynamic>;
        model = WalletModel.fromJson(parsed);
      }
    } catch (e) {
      // Ignore parse errors here; caller can log if needed.
      return;
    }

    if (model != null) {
      await saveWallet(model);
    }
  }

  Future<void> updateFundsInHold(
    String fundId,
    WalletFundsInHoldModel Function(WalletFundsInHoldModel) update,
  ) async {
    final Box<WalletFundsInHoldModel> box = await getFundsInHoldBox();
    final WalletFundsInHoldModel? model = box.get(fundId);
    if (model == null) return;
    final WalletFundsInHoldModel updated = update(model);
    await box.put(fundId, updated);
  }
}
