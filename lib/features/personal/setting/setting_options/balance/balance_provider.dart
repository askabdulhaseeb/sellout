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
import 'widgets/transfer_to_stripe_dialog.dart';

enum TransferState { idle, loading, success, error }

class BalanceProvider extends ChangeNotifier {
  WalletEntity? _wallet;
  bool _loading = true;
  String? _error;
  bool _refreshing = false;
  TransferState _transferState = TransferState.idle;
  String? _transferError;
  TransferDialogMode? _currentMode;
  double _transferAmount = 0;

  WalletEntity? get wallet => _wallet;
  bool get loading => _loading;
  String? get error => _error;
  bool get refreshing => _refreshing;
  TransferState get transferState => _transferState;
  String? get transferError => _transferError;
  TransferDialogMode? get currentMode => _currentMode;
  double get transferAmount => _transferAmount;

  bool get isProcessing => _transferState == TransferState.loading;
  bool get isSuccess => _transferState == TransferState.success;
  bool get isError => _transferState == TransferState.error;

  double get walletBalance => _wallet?.withdrawableBalance ?? 0;
  double get stripeBalance =>
      _wallet?.amountInConnectedAccount?.available ?? 0;
  String get currency => _wallet?.currency ?? 'USD';

  double get currentBalance =>
      _currentMode == TransferDialogMode.stripeToBank
          ? stripeBalance
          : walletBalance;

  void setTransferMode(TransferDialogMode mode) {
    _currentMode = mode;
    _transferState = TransferState.idle;
    _transferError = null;
    _transferAmount = 0;
    notifyListeners();
  }

  void setTransferAmount(double amount) {
    _transferAmount = amount;
    notifyListeners();
  }

  void resetTransferState() {
    _transferState = TransferState.idle;
    _transferError = null;
    notifyListeners();
  }

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

  Future<bool> executeTransfer() async {
    final String walletId = LocalAuth.stripeAccountId ?? '';
    if (walletId.isEmpty) {
      _transferState = TransferState.error;
      _transferError = 'something_wrong'.tr();
      notifyListeners();
      return false;
    }

    if (_transferAmount <= 0) {
      _transferState = TransferState.error;
      _transferError = 'nothing_to_withdraw'.tr();
      notifyListeners();
      return false;
    }

    _transferState = TransferState.loading;
    _transferError = null;
    notifyListeners();

    final TransferFundsUsecase transferUsecase = TransferFundsUsecase(
      locator(),
    );
    final DataState<bool> transferResult = await transferUsecase.call(
      TransferFundsParams(
        walletId: walletId,
        amount: _transferAmount,
        currency: currency,
      ),
    );

    if (transferResult is DataSuccess && transferResult.entity == true) {
      _transferState = TransferState.success;
      notifyListeners();
      fetchWallet(isRefresh: true);
      return true;
    } else {
      _transferState = TransferState.error;
      _transferError =
          transferResult.exception?.message ?? 'transfer_failed'.tr();
      notifyListeners();
      return false;
    }
  }

  Future<bool> executePayout() async {
    final String walletId = LocalAuth.stripeAccountId ?? '';
    if (walletId.isEmpty) {
      _transferState = TransferState.error;
      _transferError = 'something_wrong'.tr();
      notifyListeners();
      return false;
    }

    if (_transferAmount <= 0) {
      _transferState = TransferState.error;
      _transferError = 'nothing_to_withdraw'.tr();
      notifyListeners();
      return false;
    }

    _transferState = TransferState.loading;
    _transferError = null;
    notifyListeners();

    final CreatePayoutsUsecase payoutsUsecase = CreatePayoutsUsecase(
      locator(),
    );
    final DataState<WalletEntity> payoutResult = await payoutsUsecase.call(
      CreatePayoutParams(
        walletId: walletId,
        amount: _transferAmount,
        currency: currency,
      ),
    );

    if (payoutResult is DataSuccess && payoutResult.entity != null) {
      _wallet = payoutResult.entity;
      _transferState = TransferState.success;
      notifyListeners();
      fetchWallet(isRefresh: true);
      return true;
    } else {
      _transferState = TransferState.error;
      _transferError =
          payoutResult.exception?.message ?? 'withdraw_failed'.tr();
      notifyListeners();
      return false;
    }
  }

  Future<bool> executeCurrentTransfer() async {
    if (_currentMode == TransferDialogMode.walletToStripe) {
      return executeTransfer();
    } else {
      return executePayout();
    }
  }
}
