import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/app_spacings.dart';
import '../../../../../../core/helper_functions/country_helper.dart';
import '../balance_provider.dart';

import 'transfer_to_stripe_dialog/transfer_to_stripe_header.dart';
import 'transfer_to_stripe_dialog/step_indicator.dart';
import 'transfer_to_stripe_dialog/wallet_to_stripe_visual.dart';
import 'transfer_to_stripe_dialog/available_balance_text.dart';
import 'transfer_to_stripe_dialog/amount_input_section.dart';
import 'transfer_to_stripe_dialog/transfer_all_button.dart';
import 'transfer_to_stripe_dialog/slide_to_transfer_slider.dart';

enum TransferDialogMode { walletToStripe, stripeToBank }

class TransferToStripeDialog extends StatefulWidget {
  const TransferToStripeDialog({required this.mode, super.key});

  final TransferDialogMode mode;

  static Future<void> show({
    required BuildContext context,
    required TransferDialogMode mode,
  }) {
    final BalanceProvider provider = context.read<BalanceProvider>();
    provider.setTransferMode(mode);
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider<BalanceProvider>.value(
        value: provider,
        child: TransferToStripeDialog(mode: mode),
      ),
    );
  }

  @override
  State<TransferToStripeDialog> createState() => _TransferToStripeDialogState();
}

class _TransferToStripeDialogState extends State<TransferToStripeDialog> {
  final TextEditingController _amountController = TextEditingController();
  bool _isUpdatingText = false;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    _amountController.removeListener(_onAmountChanged);
    _amountController.dispose();
    super.dispose();
  }

  void _onAmountChanged() {
    if (_isUpdatingText) return;
    final String text = _amountController.text.replaceAll(',', '.');
    final double value = double.tryParse(text) ?? 0.0;
    final BalanceProvider provider = context.read<BalanceProvider>();
    if (value != provider.transferAmount) {
      provider.setTransferAmount(value);
    }
  }

  void _setPercentage(double percentage) {
    final BalanceProvider provider = context.read<BalanceProvider>();
    final double amount = provider.currentBalance * percentage;
    provider.setTransferAmount(amount);
    _isUpdatingText = true;
    _amountController.text = amount.toStringAsFixed(2);
    _amountController.selection = TextSelection.fromPosition(
      TextPosition(offset: _amountController.text.length),
    );
    _isUpdatingText = false;
  }

  void _setTransferAll() {
    HapticFeedback.lightImpact();
    _setPercentage(1.0);
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _onSliderEnd() async {
    final BalanceProvider provider = context.read<BalanceProvider>();
    if (provider.isProcessing) return;

    HapticFeedback.mediumImpact();

    final NavigatorState navigator = Navigator.of(context);

    final bool success = await provider.executeCurrentTransfer();

    if (!mounted) return;

    if (success) {
      HapticFeedback.heavyImpact();
      navigator.pop();
    } else {
      _showSnackBar(provider.transferError ?? 'something_wrong'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPayout = widget.mode == TransferDialogMode.stripeToBank;

    return Consumer<BalanceProvider>(
      builder: (BuildContext context, BalanceProvider provider, Widget? child) {
        final String symbol = CountryHelper.currencySymbolHelper(
          provider.currency,
        );
        final double balance = provider.currentBalance;

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                top: AppSpacing.lg,
                bottom:
                    MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TransferToStripeHeader(
                      onBack: provider.isProcessing
                          ? null
                          : () => Navigator.of(context).pop(),
                      title: isPayout
                          ? 'withdraw_to_bank'.tr()
                          : 'transfer_to_stripe'.tr(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    StepIndicator(currentStep: isPayout ? 2 : 1),
                    const SizedBox(height: AppSpacing.lg),
                    WalletToStripeVisual(
                      walletLabel: isPayout ? 'stripe'.tr() : 'wallet'.tr(),
                      stripeLabel: isPayout ? 'bank'.tr() : 'stripe'.tr(),
                      walletColor: isPayout
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).primaryColor,
                      stripeColor: isPayout
                          ? Colors.teal
                          : Theme.of(context).colorScheme.secondary,
                      walletIcon: isPayout
                          ? Icons.account_balance_wallet_outlined
                          : Icons.account_balance_wallet_outlined,
                      stripeIconText: isPayout ? 'B' : 'S',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AvailableBalanceText(
                      symbol: symbol,
                      walletBalance: balance,
                      availableLabel: 'available'.tr(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AmountInputSection(
                      controller: _amountController,
                      currency: provider.currency,
                      walletBalance: balance,
                      onPercentageTap: provider.isProcessing
                          ? null
                          : _setPercentage,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TransferAllButton(
                      onTap: provider.isProcessing ? null : _setTransferAll,
                      label: isPayout
                          ? 'withdraw_all'.tr()
                          : 'transfer_all'.tr(),
                      symbol: symbol,
                      walletBalance: balance,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SlideToTransferSlider(onTransfer: _onSliderEnd),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
