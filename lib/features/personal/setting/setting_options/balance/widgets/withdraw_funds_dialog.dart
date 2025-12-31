import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacings.dart';
import '../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/shadow_container.dart';

/// A modular bottom sheet dialog for withdrawing funds.
///
/// This dialog is purely presentational - all business logic should be
/// handled by the parent widget through callbacks.
///
/// Usage:
/// ```dart
/// WithdrawFundsDialog.show(
///   context: context,
///   walletBalance: 100.0,
///   stripeBalance: 50.0,
///   currency: 'USD',
///   isTransferring: false,
///   isWithdrawing: false,
///   onTransferToStripe: () => handleTransfer(),
///   onWithdrawToBank: () => handleWithdraw(),
/// );
/// ```
class WithdrawFundsDialog extends StatelessWidget {
  const WithdrawFundsDialog._({
    required this.walletBalance,
    required this.stripeBalance,
    required this.currency,
    required this.isTransferring,
    required this.isWithdrawing,
    required this.onTransferToStripe,
    required this.onWithdrawToBank,
  });

  final double walletBalance;
  final double stripeBalance;
  final String currency;
  final bool isTransferring;
  final bool isWithdrawing;
  final VoidCallback? onTransferToStripe;
  final VoidCallback? onWithdrawToBank;

  /// Shows the withdraw funds dialog as a modal bottom sheet.
  static Future<void> show({
    required BuildContext context,
    required double walletBalance,
    required double stripeBalance,
    required String currency,
    required bool isTransferring,
    required bool isWithdrawing,
    required VoidCallback? onTransferToStripe,
    required VoidCallback? onWithdrawToBank,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => WithdrawFundsDialog._(
        walletBalance: walletBalance,
        stripeBalance: stripeBalance,
        currency: currency,
        isTransferring: isTransferring,
        isWithdrawing: isWithdrawing,
        onTransferToStripe: onTransferToStripe,
        onWithdrawToBank: onWithdrawToBank,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String symbol = CountryHelper.currencySymbolHelper(currency);
    final bool canTransferToStripe = walletBalance > 0 && !isTransferring;
    final bool canWithdrawToBank = stripeBalance > 0 && !isWithdrawing;

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
              _DialogHeader(onClose: () => Navigator.of(context).pop()),
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

              // Info section
              const _InfoSection(),
              const SizedBox(height: AppSpacing.lg),

              // Step 1: Transfer to Stripe
              _WithdrawStepTile(
                icon: Icons.account_balance_wallet_outlined,
                iconColor: Theme.of(context).colorScheme.primary,
                iconBackgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                title: tr('transfer_to_stripe', context: context),
                stepLabel: tr('step_1', context: context),
                subtitle: tr(
                  'legal_documents.move_funds_from_wallet_to_stripe',
                  context: context,
                ),
                onTap: canTransferToStripe ? onTransferToStripe : null,
                isLoading: isTransferring,
              ),
              const SizedBox(height: AppSpacing.md),

              // Step 2: Withdraw to Bank
              _WithdrawStepTile(
                icon: 'S',
                iconColor: Theme.of(context).colorScheme.secondary,
                iconBackgroundColor: Theme.of(
                  context,
                ).colorScheme.secondary.withValues(alpha: 0.1),
                title: tr('withdraw_to_bank', context: context),
                stepLabel: tr('step_2', context: context),
                subtitle: tr(
                  'legal_documents.transfer_from_stripe_to_bank',
                  context: context,
                ),
                onTap: canWithdrawToBank ? onWithdrawToBank : null,
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

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          tr('withdraw_funds', context: context),
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: onClose,
          icon: const Icon(Icons.close),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.lightPrimaryColor.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.info_outline,
              color: AppColors.primaryColor,
              size: 18,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'two_step_withdrawal_process'.tr(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'two_step_withdrawal_desc'.tr(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.subtitleLight,
                  ),
                ),
              ],
            ),
          ),
        ],
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
    final ThemeData theme = Theme.of(context);
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
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: iconColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                title,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            amount,
            style: theme.textTheme.headlineSmall?.copyWith(
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
    final ThemeData theme = Theme.of(context);
    final bool isDisabled = onTap == null && !isLoading;

    return ShadowContainer(
      onTap: isLoading ? null : onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Row(
          children: <Widget>[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: icon is IconData
                    ? Icon(icon as IconData, color: iconColor, size: 22)
                    : Text(
                        icon.toString(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: iconColor,
                          fontWeight: FontWeight.bold,
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
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          stepLabel,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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
              Icon(Icons.chevron_right, color: theme.colorScheme.outline),
          ],
        ),
      ),
    );
  }
}
