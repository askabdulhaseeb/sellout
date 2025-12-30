import '../../../../../core/sources/data_state.dart';
import '../../../payment/domain/entities/wallet_entity.dart';
import '../../../payment/domain/params/create_payout_params.dart';
import '../../../payment/domain/params/transfer_funds_params.dart';
import '../../../payment/domain/usecase/create_payouts_usecase.dart';
import '../../../payment/domain/usecase/get_wallet_usecase.dart';
import '../../../payment/domain/usecase/transfer_funds_usecase.dart';
import 'balance_skeleton.dart';
import 'package:flutter/material.dart';
import '../../../../../services/get_it.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'widgets/balance_summary_card.dart';
import 'widgets/funds_in_hold_section.dart';
import 'widgets/transaction_history_section.dart';
import 'widgets/transfer_to_stripe_dialog.dart';
import 'widgets/withdraw_funds_dialog.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});
  static String routeName = '/balance';

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  WalletEntity? _wallet;
  bool _loading = true;
  String? _error;
  bool _isTransferring = false;
  bool _isWithdrawing = false;
  bool _refreshing = false;

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
    if (!mounted) return;
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
    final DataState<WalletEntity> result = await usecase.call(walletId);
    if (!mounted) return;
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

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showWithdrawDialog() {
    final WalletEntity? wallet = _wallet;
    if (wallet == null) return;
    if (!mounted) return;

    final double stripeBalance =
        wallet.amountInConnectedAccount?.available ?? 0;

    WithdrawFundsDialog.show(
      context: context,
      walletBalance: wallet.withdrawableBalance,
      stripeBalance: stripeBalance,
      currency: wallet.currency,
      isTransferring: _isTransferring,
      isWithdrawing: _isWithdrawing,
      onTransferToStripe: () => _showTransferToStripeDialog(),
      onWithdrawToBank: () => _showPayoutDialog(),
    );
  }

  void _showTransferToStripeDialog() {
    final WalletEntity? wallet = _wallet;
    if (wallet == null) return;
    if (!mounted) return;
    Navigator.of(context).pop();
    if (!mounted) return;
    TransferToStripeDialog.show(
      context: context,
      balance: wallet.withdrawableBalance,
      currency: wallet.currency,
      onAction: _executeTransfer,
      mode: TransferDialogMode.walletToStripe,
    );
  }

  void _showPayoutDialog() {
    final WalletEntity? wallet = _wallet;
    if (wallet == null) return;
    if (!mounted) return;
    Navigator.of(context).pop();
    if (!mounted) return;
    TransferToStripeDialog.show(
      context: context,
      balance: wallet.amountInConnectedAccount?.available ?? 0,
      currency: wallet.currency,
      onAction: _executePayout,
      mode: TransferDialogMode.stripeToBank,
    );
  }

  Future<void> _executeTransfer(double amount) async {
    final WalletEntity? wallet = _wallet;
    if (wallet == null) return;

    final String walletId = LocalAuth.stripeAccountId ?? '';
    if (walletId.isEmpty) {
      _showSnackBar('something_wrong'.tr());
      return;
    }

    if (amount <= 0) {
      _showSnackBar('nothing_to_withdraw'.tr());
      return;
    }

    if (_isTransferring) return;
    if (!mounted) return;
    setState(() => _isTransferring = true);

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

      if (!mounted) return;
      if (transferResult is DataSuccess && transferResult.entity == true) {
        _showSnackBar('transfer_success'.tr());
      } else {
        _showSnackBar(
          transferResult.exception?.message ?? 'transfer_failed'.tr(),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isTransferring = false);
      }
      await _fetchWallet(isRefresh: true);
    }
  }

  Future<void> _executePayout(double amount) async {
    final WalletEntity? wallet = _wallet;
    if (wallet == null) return;

    final String walletId = LocalAuth.stripeAccountId ?? '';
    if (walletId.isEmpty) {
      _showSnackBar('something_wrong'.tr());
      return;
    }

    if (amount <= 0) {
      _showSnackBar('nothing_to_withdraw'.tr());
      return;
    }

    if (_isWithdrawing) return;
    if (!mounted) return;
    setState(() => _isWithdrawing = true);

    try {
      final CreatePayoutsUsecase payoutsUsecase = CreatePayoutsUsecase(
        locator(),
      );
      final DataState<WalletEntity> payoutResult = await payoutsUsecase.call(
        CreatePayoutParams(
          walletId: walletId,
          amount: amount,
          currency: wallet.currency,
        ),
      );

      if (!mounted) return;
      if (payoutResult is DataSuccess && payoutResult.entity != null) {
        setState(() {
          _wallet = payoutResult.entity;
        });
        _showSnackBar('withdraw_success'.tr());
      } else {
        _showSnackBar(
          payoutResult.exception?.message ?? 'withdraw_failed'.tr(),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isWithdrawing = false);
      }
      await _fetchWallet(isRefresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final WalletEntity? wallet = _wallet;

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
                    isWithdrawing: _isWithdrawing || _isTransferring,
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
