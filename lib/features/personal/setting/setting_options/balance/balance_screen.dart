import 'package:flutter/material.dart';
import '../../../../../services/get_it.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../payment/domain/params/create_payout_params.dart';
import '../../../payment/domain/params/transfer_funds_params.dart';
import '../../../payment/domain/usecase/create_payouts_usecase.dart';
import '../../../payment/domain/usecase/get_wallet_usecase.dart';
import '../../../payment/domain/usecase/transfer_funds_usecase.dart';
import '../../../payment/data/models/wallet_model.dart';
import '../../../../../core/sources/data_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'balance_skeleton.dart';
import 'widgets/balance_summary_card.dart';
import 'widgets/funds_in_hold_section.dart';
import 'widgets/transaction_history_section.dart';
import 'widgets/withdraw_funds_dialog.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});
  static String routeName = '/balance';

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  WalletModel? _wallet;
  bool _loading = true;
  String? _error;
  bool _withdrawing = false;
  bool _refreshing = false;
  bool _isTransferring = false;

  @override
  void initState() {
    super.initState();
    _fetchWallet();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchWallet({bool isRefresh = false}) async {
    setState(() {
      if (isRefresh) {
        _refreshing = true;
      } else {
        _loading = true;
      }
      _error = null;
    });
    final String walletId = LocalAuth.stripeAccountId ?? '';
    final GetWalletUsecase usecase = GetWalletUsecase(locator());
    final DataState<WalletModel> result = await usecase.call(walletId);
    if (result is DataSuccess && result.entity != null) {
      setState(() {
        _wallet = result.entity;
        _loading = false;
        _refreshing = false;
      });
    } else {
      setState(() {
        _error = result.exception?.message ?? 'something_wrong'.tr();
        _loading = false;
        _refreshing = false;
      });
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showWithdrawDialog() {
    final WalletModel? wallet = _wallet;
    if (wallet == null) return;

    WithdrawFundsDialog.show(
      context: context,
      walletBalance: wallet.withdrawableBalance,
      stripeBalance: wallet.amountInConnectedAccount?.available ?? 0,
      currency: wallet.currency,
      onTransferToStripe: _transferToStripe,
      onWithdrawToBank: _payoutToBank,
      isTransferring: _isTransferring,
      isWithdrawing: _withdrawing,
    );
  }

  Future<void> _transferToStripe() async {
    final WalletModel? wallet = _wallet;
    if (wallet == null) return;

    final String walletId = LocalAuth.stripeAccountId ?? '';
    if (walletId.isEmpty) {
      _showSnack('something_wrong'.tr());
      return;
    }

    final double amount = wallet.withdrawableBalance;
    if (amount <= 0) {
      _showSnack('nothing_to_withdraw'.tr());
      return;
    }

    if (_isTransferring) return;
    setState(() => _isTransferring = true);
    Navigator.of(context).pop();

    try {
      final TransferFundsUsecase transferUsecase = TransferFundsUsecase(
        locator(),
      );
      final DataState<bool> transferResult = await transferUsecase.call(
        TransferFundsParams(
          walletId: walletId,
          amount: amount,
          currency: wallet.currency,
        ),
      );

      if (transferResult is DataSuccess && transferResult.entity == true) {
        _showSnack('withdraw_success'.tr());
      } else {
        _showSnack(transferResult.exception?.message ?? 'withdraw_failed'.tr());
      }
    } finally {
      if (mounted) {
        setState(() => _isTransferring = false);
      }
      await _fetchWallet();
    }
  }

  Future<void> _payoutToBank() async {
    final WalletModel? wallet = _wallet;
    if (wallet == null) return;

    final String walletId = LocalAuth.stripeAccountId ?? '';
    if (walletId.isEmpty) {
      _showSnack('something_wrong'.tr());
      return;
    }

    final double stripeBalance = wallet.amountInConnectedAccount?.available ?? 0;
    if (stripeBalance <= 0) {
      _showSnack('nothing_to_withdraw'.tr());
      return;
    }

    if (_withdrawing) return;
    setState(() => _withdrawing = true);
    Navigator.of(context).pop();

    try {
      final CreatePayoutsUsecase payoutsUsecase = CreatePayoutsUsecase(
        locator(),
      );
      final DataState<WalletModel> payoutResult = await payoutsUsecase.call(
        CreatePayoutParams(
          walletId: walletId,
          amount: stripeBalance,
          currency: wallet.currency,
        ),
      );

      if (payoutResult is DataSuccess && payoutResult.entity != null) {
        setState(() {
          _wallet = payoutResult.entity;
        });
        _showSnack('withdraw_success'.tr());
      } else {
        _showSnack(payoutResult.exception?.message ?? 'withdraw_failed'.tr());
      }
    } finally {
      if (mounted) {
        setState(() => _withdrawing = false);
      }
      await _fetchWallet();
    }
  }

  @override
  Widget build(BuildContext context) {
    final WalletModel? wallet = _wallet;

    return Scaffold(
      appBar: AppBar(title: Text('balance'.tr())),
      body: _loading
          ? const BalanceSkeleton()
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(_error!, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _fetchWallet,
                      child: Text('retry'.tr()),
                    ),
                  ],
                ),
              ),
            )
          : wallet == null
          ? const BalanceSkeleton()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  BalanceSummaryCard(
                    wallet: wallet,
                    isWithdrawing: _withdrawing,
                    isRefreshing: _refreshing,
                    onWithdrawTap: _showWithdrawDialog,
                    onRefreshTap: () => _fetchWallet(isRefresh: true),
                  ),
                  const SizedBox(height: 16),
                  FundsInHoldSection(fundsInHold: wallet.fundsInHold),
                  const SizedBox(height: 16),
                  TransactionHistorySection(
                    transactionHistory: wallet.transactionHistory,
                  ),
                ],
              ),
            ),
    );
  }
}
