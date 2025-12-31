import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../services/get_it.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../payment/domain/entities/wallet_entity.dart';
import '../../../../payment/data/sources/local/local_wallet.dart';
import '../../../../payment/domain/params/create_payout_params.dart';
import '../../../../payment/domain/params/get_wallet_params.dart';
import '../../../../payment/domain/params/transfer_funds_params.dart';
import '../../../../payment/domain/usecase/create_payouts_usecase.dart';
import '../../../../payment/domain/usecase/get_wallet_usecase.dart';
import '../../../../payment/domain/usecase/transfer_funds_usecase.dart';
import '../widgets/transfer_dialog/transfer_dialog.dart';

enum TransferState { idle, loading, success, error }

class BalanceProvider extends ChangeNotifier {
  BalanceProvider() {
    LocalWallet.walletUpdatedNotifier.addListener(_onLocalWalletUpdated);
  }

  // Load cached wallet immediately so UI shows local data without waiting
  // for network fetch.
  void initFromCache() {
    final String currentId = LocalAuth.stripeAccountId ?? '';
    if (currentId.isEmpty) return;
    final WalletEntity? local = LocalWallet().getWallet(currentId);
    if (local != null) {
      _wallet = local;
      _loading = false;
      _refreshing = false;
      notifyListeners();
    }
  }

  void _onLocalWalletUpdated() {
    final String? updatedId = LocalWallet.walletUpdatedNotifier.value;
    final String currentId = LocalAuth.stripeAccountId ?? '';
    if (updatedId == null || updatedId != currentId) return;
    final WalletEntity? local = LocalWallet().getWallet(currentId);
    if (local != null) {
      _wallet = local;
      _loading = false;
      _refreshing = false;
      notifyListeners();
    }
  }

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setRefreshing(bool value) {
    _refreshing = value;
    notifyListeners();
  }

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
  double get stripeBalance => _wallet?.amountInConnectedAccount?.available ?? 0;
  String get currency => _wallet?.currency ?? 'USD';

  double get currentBalance => _currentMode == TransferDialogMode.stripeToBank
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
    _prepareWalletFetch(isRefresh);
    final String walletId = LocalAuth.stripeAccountId ?? '';
    final DataState<WalletEntity> result = await _getWallet(
      walletId,
      isRefresh,
    );
    _handleWalletFetchResult(result);
  }

  void _prepareWalletFetch(bool isRefresh) {
    if (isRefresh) {
      setRefreshing(true);
    } else {
      setLoading(true);
    }
    _error = null;
  }

  Future<DataState<WalletEntity>> _getWallet(
    String walletId,
    bool isRefresh,
  ) async {
    final GetWalletUsecase usecase = GetWalletUsecase(locator());
    return await usecase.call(
      GetWalletParams(walletId: walletId, refresh: isRefresh),
    );
  }

  void _handleWalletFetchResult(DataState<WalletEntity> result) {
    if (result is DataSuccess && result.entity != null) {
      _wallet = result.entity;
      setLoading(false);
      setRefreshing(false);
    } else {
      _error = result.exception?.message ?? 'something_wrong'.tr();
      setLoading(false);
      setRefreshing(false);
    }
  }

  Future<bool> executeTransfer() async {
    final String walletId = LocalAuth.stripeAccountId ?? '';
    if (!_validateTransfer(walletId)) return false;
    _setTransferLoading();
    final DataState<bool> transferResult = await _performTransfer(walletId);
    return _handleTransferResult(transferResult);
  }

  bool _validateTransfer(String walletId) {
    if (walletId.isEmpty) {
      _setTransferError('something_wrong'.tr());
      return false;
    }
    if (_transferAmount <= 0) {
      _setTransferError('nothing_to_withdraw'.tr());
      return false;
    }
    return true;
  }

  void _setTransferLoading() {
    _transferState = TransferState.loading;
    _transferError = null;
    notifyListeners();
  }

  void _setTransferError(String error) {
    _transferState = TransferState.error;
    _transferError = error;
    notifyListeners();
  }

  Future<DataState<bool>> _performTransfer(String walletId) async {
    final TransferFundsUsecase transferUsecase = TransferFundsUsecase(
      locator(),
    );
    return await transferUsecase.call(
      TransferFundsParams(
        walletId: walletId,
        amount: _transferAmount,
        currency: currency,
      ),
    );
  }

  bool _handleTransferResult(DataState<bool> transferResult) {
    if (transferResult is DataSuccess && transferResult.entity == true) {
      _transferState = TransferState.success;
      notifyListeners();
      return true;
    } else {
      _setTransferError(
        transferResult.exception?.message ?? 'transfer_failed'.tr(),
      );
      return false;
    }
  }

  Future<bool> executePayout() async {
    final String walletId = LocalAuth.stripeAccountId ?? '';
    if (!_validateTransfer(walletId)) return false;
    _setTransferLoading();
    final DataState<bool> payoutResult = await _performPayout(walletId);
    return _handlePayoutResult(payoutResult);
  }

  Future<DataState<bool>> _performPayout(String walletId) async {
    final CreatePayoutsUsecase payoutsUsecase = CreatePayoutsUsecase(locator());
    return await payoutsUsecase.call(
      CreatePayoutParams(
        walletId: walletId,
        amount: _transferAmount,
        currency: currency,
      ),
    );
  }

  bool _handlePayoutResult(DataState<bool> payoutResult) {
    if (payoutResult is DataSuccess) {
      notifyListeners();
      return true;
    } else {
      _setTransferError(
        payoutResult.exception?.message ?? 'withdraw_failed'.tr(),
      );
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

  @override
  void dispose() {
    try {
      LocalWallet.walletUpdatedNotifier.removeListener(_onLocalWalletUpdated);
    } catch (_) {}
    super.dispose();
  }
}
