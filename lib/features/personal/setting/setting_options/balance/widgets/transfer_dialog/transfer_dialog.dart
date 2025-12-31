import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../core/helper_functions/country_helper.dart';
import '../../provider/balance_provider.dart';
import 'widgets/transfer_dialog_header.dart';
import 'widgets/step_indicator.dart';
import 'widgets/transfer_visual.dart';
import 'widgets/available_balance_text.dart';
import 'widgets/amount_input_section.dart';
import 'widgets/transfer_all_button.dart';
import 'widgets/slide_to_transfer_slider.dart';

enum TransferDialogMode { walletToStripe, stripeToBank }

class TransferDialog extends StatefulWidget {
  const TransferDialog({required this.mode, super.key});

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
        child: TransferDialog(mode: mode),
      ),
    );
  }

  @override
  State<TransferDialog> createState() => _TransferDialogState();
}

class _TransferDialogState extends State<TransferDialog> {
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
      // Ensure dialog closes after success
      if (navigator.canPop()) {
        navigator.pop();
      }
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
                    TransferDialogHeader(
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
                    TransferVisual(
                      sourceLabel: isPayout ? 'stripe'.tr() : 'wallet'.tr(),
                      destinationLabel: isPayout ? 'bank'.tr() : 'stripe'.tr(),
                      sourceColor: isPayout
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).primaryColor,
                      destinationColor: isPayout
                          ? Colors.teal
                          : Theme.of(context).colorScheme.secondary,
                      sourceIcon: isPayout
                          ? Icons.account_balance_wallet_outlined
                          : Icons.account_balance_wallet_outlined,
                      destinationIconText: isPayout ? 'B' : 'S',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AvailableBalanceText(
                      symbol: symbol,
                      balance: balance,
                      availableLabel: 'available'.tr(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AmountInputSection(
                      controller: _amountController,
                      currency: provider.currency,
                      maxAmount: balance,
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
                      amount: balance,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SlideToTransferSlider(
                      onTransfer: _onSliderEnd,
                      canTransfer:
                          provider.transferAmount > 0 &&
                          provider.transferAmount <= balance &&
                          !provider.isProcessing &&
                          !provider.isSuccess,
                      isLoading: provider.isProcessing,
                      isSuccess: provider.isSuccess,
                    ),
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
