import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../core/constants/app_spacings.dart';
import '../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/shadow_container.dart';

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
      builder: (BuildContext context) => TransferToStripeDialog(
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
    final double? amount = double.tryParse(_amountController.text);
    if (amount != null && amount >= 0 && amount <= widget.walletBalance) {
      setState(() {
        _selectedAmount = amount;
      });
    }
  }

  void _setPercentage(double percentage) {
    final double amount = (widget.walletBalance * percentage).floorToDouble();
    setState(() {
      _selectedAmount = amount;
      _amountController.text = amount.toStringAsFixed(2);
    });
  }

  void _setTransferAll() {
    setState(() {
      _selectedAmount = widget.walletBalance;
      _amountController.text = widget.walletBalance.toStringAsFixed(2);
    });
  }

  void _onSliderChanged(double value) {
    setState(() {
      _sliderValue = value;
    });
  }

  void _onSliderEnd(double value) {
    if (value >= 0.9 && _selectedAmount > 0) {
      widget.onTransfer(_selectedAmount);
    } else {
      setState(() {
        _sliderValue = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String symbol = CountryHelper.currencySymbolHelper(widget.currency);
    final bool canTransfer = _selectedAmount > 0 && _selectedAmount <= widget.walletBalance;

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
                // Header with back button
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back_ios, size: 20),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'transfer_to_stripe'.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Step indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 2,
                      color: Colors.grey[300],
                    ),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '2',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Wallet to Stripe visual
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildIconBox(
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'wallet'.tr(),
                      color: AppColors.primaryColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Container(
                        width: 30,
                        height: 2,
                        color: Colors.grey[300],
                      ),
                    ),
                    _buildIconBox(
                      iconText: 'S',
                      label: 'stripe'.tr(),
                      color: AppColors.secondaryColor,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Available balance
                Text(
                  '${'available'.tr()}: $symbol${widget.walletBalance.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Amount input
                ShadowContainer(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            widget.currency.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            width: 1,
                            height: 24,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: TextField(
                              controller: _amountController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                              ],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: '0.00',
                                hintStyle: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[400],
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Percentage buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _buildPercentageButton('25%', 0.25),
                          _buildPercentageButton('50%', 0.50),
                          _buildPercentageButton('75%', 0.75),
                          _buildPercentageButton('100%', 1.0),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Transfer All button
                ShadowContainer(
                  onTap: _setTransferAll,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '${'transfer_all'.tr()} ($symbol${widget.walletBalance.toStringAsFixed(2)})',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Slide to transfer
                _buildSlideToTransfer(canTransfer),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconBox({
    IconData? icon,
    String? iconText,
    required String label,
    required Color color,
  }) {
    return Column(
      children: <Widget>[
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: icon != null
                ? Icon(icon, color: color, size: 28)
                : Text(
                    iconText ?? '',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPercentageButton(String label, double percentage) {
    return GestureDetector(
      onTap: () => _setPercentage(percentage),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget _buildSlideToTransfer(bool canTransfer) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: canTransfer ? AppColors.primaryColor.withValues(alpha: 0.1) : Colors.grey[200],
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        children: <Widget>[
          // Background progress
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: (MediaQuery.of(context).size.width - 32) * _sliderValue,
            height: 56,
            decoration: BoxDecoration(
              color: canTransfer ? AppColors.primaryColor.withValues(alpha: 0.3) : Colors.grey[300],
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          // Slider
          Row(
            children: <Widget>[
              GestureDetector(
                onHorizontalDragUpdate: canTransfer
                    ? (DragUpdateDetails details) {
                        final double newValue = (details.localPosition.dx /
                                (MediaQuery.of(context).size.width - 80))
                            .clamp(0.0, 1.0);
                        _onSliderChanged(newValue);
                      }
                    : null,
                onHorizontalDragEnd: canTransfer
                    ? (DragEndDetails details) {
                        _onSliderEnd(_sliderValue);
                      }
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  margin: EdgeInsets.only(
                    left: ((MediaQuery.of(context).size.width - 80) * _sliderValue)
                        .clamp(4.0, MediaQuery.of(context).size.width - 80),
                  ),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: canTransfer ? AppColors.primaryColor : Colors.grey[400],
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          // Center text
          Center(
            child: Text(
              'slide_to_transfer'.tr(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: canTransfer ? AppColors.primaryColor : Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
