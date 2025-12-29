import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacings.dart';
import '../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/shadow_container.dart';

class WithdrawFundsDialog extends StatelessWidget {
  const WithdrawFundsDialog({
    required this.walletBalance,
    required this.stripeBalance,
    required this.currency,
    required this.onTransferToStripe,
    required this.onWithdrawToBank,
    this.isTransferring = false,
    this.isWithdrawing = false,
    super.key,
  });

  final double walletBalance;
  final double stripeBalance;
  final String currency;
  final VoidCallback onTransferToStripe;
  final VoidCallback onWithdrawToBank;
  final bool isTransferring;
  final bool isWithdrawing;

  static Future<void> show({
    required BuildContext context,
    required double walletBalance,
    required double stripeBalance,
    required String currency,
    required VoidCallback onTransferToStripe,
    required VoidCallback onWithdrawToBank,
    bool isTransferring = false,
    bool isWithdrawing = false,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => WithdrawFundsDialog(
        walletBalance: walletBalance,
        stripeBalance: stripeBalance,
        currency: currency,
        onTransferToStripe: onTransferToStripe,
        onWithdrawToBank: onWithdrawToBank,
        isTransferring: isTransferring,
        isWithdrawing: isWithdrawing,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String symbol = CountryHelper.currencySymbolHelper(currency);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'withdraw_funds'.tr(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              // Info banner
              ShadowContainer(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'two_step_withdrawal_process'.tr(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'two_step_withdrawal_desc'.tr(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Balance cards row
              Row(
                children: <Widget>[
                  Expanded(
                    child: _MiniBalanceCard(
                      icon: Icons.account_balance_wallet_outlined,
                      iconColor: AppColors.primaryColor,
                      title: 'wallet'.tr(),
                      amount: '$symbol${walletBalance.toStringAsFixed(2)}',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _MiniBalanceCard(
                      iconText: 'S',
                      iconColor: AppColors.secondaryColor,
                      title: 'stripe'.tr(),
                      amount: '$symbol${stripeBalance.toStringAsFixed(2)}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              // Step 1 - Transfer to Stripe
              _WithdrawStepTile(
                icon: 'S',
                iconColor: AppColors.secondaryColor,
                iconBackgroundColor: AppColors.secondaryColor.withValues(alpha: 0.1),
                title: 'transfer_to_stripe'.tr(),
                stepLabel: 'step_1'.tr(),
                subtitle: 'transfer_to_stripe_desc'.tr(),
                onTap: walletBalance > 0 && !isTransferring
                    ? onTransferToStripe
                    : null,
                isLoading: isTransferring,
              ),
              const SizedBox(height: AppSpacing.md),
              // Step 2 - Withdraw to Bank
              _WithdrawStepTile(
                icon: Icons.account_balance,
                iconColor: Colors.teal,
                iconBackgroundColor: Colors.teal.withValues(alpha: 0.1),
                title: 'withdraw_to_bank'.tr(),
                stepLabel: 'step_2'.tr(),
                subtitle: 'withdraw_to_bank_desc'.tr(),
                onTap: stripeBalance > 0 && !isWithdrawing
                    ? onWithdrawToBank
                    : null,
                isLoading: isWithdrawing,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniBalanceCard extends StatelessWidget {
  const _MiniBalanceCard({
    required this.title,
    required this.amount,
    required this.iconColor,
    this.icon,
    this.iconText,
  });

  final IconData? icon;
  final String? iconText;
  final Color iconColor;
  final String title;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              if (icon != null)
                Icon(icon, color: iconColor, size: 18)
              else if (iconText != null)
                Text(
                  iconText!,
                  style: TextStyle(
                    color: iconColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _WithdrawStepTile extends StatelessWidget {
  const _WithdrawStepTile({
    required this.title,
    required this.stepLabel,
    required this.subtitle,
    required this.iconColor,
    required this.iconBackgroundColor,
    this.icon,
    this.onTap,
    this.isLoading = false,
  });

  final dynamic icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String title;
  final String stepLabel;
  final String subtitle;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onTap == null && !isLoading;

    return ShadowContainer(
      onTap: isLoading ? null : onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Row(
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: icon is IconData
                    ? Icon(icon as IconData, color: iconColor, size: 22)
                    : Text(
                        icon.toString(),
                        style: TextStyle(
                          color: iconColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          stepLabel,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
          ],
        ),
      ),
    );
  }
}
