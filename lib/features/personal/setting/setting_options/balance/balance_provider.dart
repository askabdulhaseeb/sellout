import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/sources/data_state.dart';
import '../../../../../services/get_it.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../payment/domain/entities/wallet_entity.dart';
import '../../../payment/domain/params/create_payout_params.dart';
import '../../../payment/domain/params/transfer_funds_params.dart';
import '../../../payment/domain/usecase/create_payouts_usecase.dart';
import '../../../payment/domain/usecase/get_wallet_usecase.dart';
import '../../../payment/domain/usecase/transfer_funds_usecase.dart';

class BalanceProvider extends ChangeNotifier {
  WalletEntity? _wallet;
  bool _loading = true;
  String? _error;
  bool _refreshing = false;
  bool _isProcessing = false;

  WalletEntity? get wallet => _wallet;
  bool get loading => _loading;
  String? get error => _error;
  bool get refreshing => _refreshing;
  bool get isProcessing => _isProcessing;

  double get walletBalance => _wallet?.withdrawableBalance ?? 0;
  double get stripeBalance => _wallet?.amountInConnectedAccount?.available ?? 0;
  String get currency => _wallet?.currency ?? 'USD';

  Future<void> fetchWallet({bool isRefresh = false}) async {
    if (isRefresh) {
      _refreshing = true;
    } else {
      _loading = true;
    }
    _error = null;
    notifyListeners();

    final String walletId = LocalAuth.stripeAccountId ?? '';
    final GetWalletUsecase usecase = GetWalletUsecase(locator());
    final DataState<WalletEntity> result = await usecase.call(walletId);

    if (result is DataSuccess && result.entity != null) {
      _wallet = result.entity;
      _loading = false;
      _refreshing = false;
    } else {
      _error = result.exception?.message ?? 'something_wrong'.tr();
      _loading = false;
      _refreshing = false;
    }
    notifyListeners();
  }

  Future<String?> executeTransfer(double amount) async {
    final String walletId = LocalAuth.stripeAccountId ?? '';
    if (walletId.isEmpty) {
      return 'something_wrong'.tr();
    }

    if (amount <= 0) {
      return 'nothing_to_withdraw'.tr();
    }

    _isProcessing = true;
    notifyListeners();

    try {
      final TransferFundsUsecase transferUsecase = TransferFundsUsecase(
        locator(),
      );
      final DataState<bool> transferResult = await transferUsecase.call(
        TransferFundsParams(
          walletId: walletId,
          amount: amount,
          currency: currency,
        ),
      );

      if (transferResult is DataSuccess && transferResult.entity == true) {
        await fetchWallet(isRefresh: true);
        return null; // Success
      } else {
        return transferResult.exception?.message ?? 'transfer_failed'.tr();
      }
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<String?> executePayout(double amount) async {
    final String walletId = LocalAuth.stripeAccountId ?? '';
    if (walletId.isEmpty) {
      return 'something_wrong'.tr();
    }

    if (amount <= 0) {
      return 'nothing_to_withdraw'.tr();
    }

    _isProcessing = true;
    notifyListeners();

    try {
      final CreatePayoutsUsecase payoutsUsecase = CreatePayoutsUsecase(
        locator(),
      );
      final DataState<WalletEntity> payoutResult = await payoutsUsecase.call(
        CreatePayoutParams(
          walletId: walletId,
          amount: amount,
          currency: currency,
        ),
      );

      if (payoutResult is DataSuccess && payoutResult.entity != null) {
        _wallet = payoutResult.entity;
        notifyListeners();
        await fetchWallet(isRefresh: true);
        return null; // Success
      } else {
        return payoutResult.exception?.message ?? 'withdraw_failed'.tr();
      }
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
}
