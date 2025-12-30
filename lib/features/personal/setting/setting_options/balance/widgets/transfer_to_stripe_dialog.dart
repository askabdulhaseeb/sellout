import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../core/constants/app_spacings.dart';
import '../../../../../../core/helper_functions/country_helper.dart';

import 'transfer_to_stripe_dialog/transfer_to_stripe_header.dart';
import 'transfer_to_stripe_dialog/step_indicator.dart';
import 'transfer_to_stripe_dialog/wallet_to_stripe_visual.dart';
import 'transfer_to_stripe_dialog/available_balance_text.dart';
import 'transfer_to_stripe_dialog/amount_input_section.dart';
import 'transfer_to_stripe_dialog/transfer_all_button.dart';
import 'transfer_to_stripe_dialog/slide_to_transfer_slider.dart';

class TransferToStripeDialog extends StatefulWidget {
  const TransferToStripeDialog({
    required this.walletBalance,
    required this.currency,
    required this.onTransfer,
    super.key,
  });

  final double walletBalance;
  final String currency;
  final void Function(double amount) onTransfer;

  static Future<void> show({
    required BuildContext context,
    required double walletBalance,
    required String currency,
    required void Function(double amount) onTransfer,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TransferToStripeDialog(
        walletBalance: walletBalance,
        currency: currency,
        onTransfer: onTransfer,
      ),
    );
  }

  @override
  State<TransferToStripeDialog> createState() => _TransferToStripeDialogState();
}

class _TransferToStripeDialogState extends State<TransferToStripeDialog> {
  final TextEditingController _amountController = TextEditingController();

  double _sliderValue = 0.0;
  double _selectedAmount = 0.0;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _setPercentage(double percentage) {
    setState(() {
      _sliderValue = percentage;
      _selectedAmount = widget.walletBalance * percentage;
      _amountController.text = _selectedAmount.toStringAsFixed(2);
    });
  }

  void _setTransferAll() {
    HapticFeedback.lightImpact();
    _setPercentage(1.0);
  }

  void _onSliderChanged(double value) {
    setState(() {
      _sliderValue = value;
      _selectedAmount = widget.walletBalance * value;
      _amountController.text = _selectedAmount.toStringAsFixed(2);
    });
  }

  void _onSliderEnd() {
    final bool canTransfer =
        _selectedAmount > 0 && _selectedAmount <= widget.walletBalance;

    if (!canTransfer) return;

    HapticFeedback.mediumImpact();
    widget.onTransfer(_selectedAmount);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final String symbol = CountryHelper.currencySymbolHelper(widget.currency);

    final bool canTransfer =
        _selectedAmount > 0 && _selectedAmount <= widget.walletBalance;

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
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TransferToStripeHeader(
                  onBack: () => Navigator.of(context).pop(),
                  title: 'transfer_to_stripe'.tr(),
                ),

                const SizedBox(height: AppSpacing.lg),
                const StepIndicator(currentStep: 2),
                const SizedBox(height: AppSpacing.lg),

                WalletToStripeVisual(
                  walletLabel: 'wallet'.tr(),
                  stripeLabel: 'stripe'.tr(),
                  walletColor: Theme.of(context).primaryColor,
                  stripeColor: Theme.of(context).colorScheme.secondary,
                  walletIcon: Icons.account_balance_wallet_outlined,
                  stripeIconText: 'S',
                ),

                const SizedBox(height: AppSpacing.md),

                AvailableBalanceText(
                  symbol: symbol,
                  walletBalance: widget.walletBalance,
                  availableLabel: 'available'.tr(),
                ),

                const SizedBox(height: AppSpacing.lg),

                AmountInputSection(
                  controller: _amountController,
                  currency: widget.currency,
                  walletBalance: widget.walletBalance,
                  onPercentageTap: _setPercentage,
                ),

                const SizedBox(height: AppSpacing.md),

                TransferAllButton(
                  onTap: _setTransferAll,
                  label: 'transfer_all'.tr(),
                  symbol: symbol,
                  walletBalance: widget.walletBalance,
                ),

                const SizedBox(height: AppSpacing.lg),

                SlideToTransferSlider(
                  sliderValue: _sliderValue,
                  canTransfer: canTransfer,
                  onChanged: _onSliderChanged,
                  onTransfer: _onSliderEnd,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
