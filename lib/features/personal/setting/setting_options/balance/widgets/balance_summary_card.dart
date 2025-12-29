import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/shadow_container.dart';
import '../../../../../../core/constants/app_spacings.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../payment/data/models/wallet_model.dart';

class BalanceSummaryCard extends StatelessWidget {
  const BalanceSummaryCard({
    required this.wallet,
    required this.onWithdrawTap,
    required this.onRefreshTap,
    this.isWithdrawing = false,
    this.isRefreshing = false,
    super.key,
  });

  final WalletModel wallet;
  final VoidCallback onWithdrawTap;
  final VoidCallback onRefreshTap;
  final bool isWithdrawing;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    final String symbol = CountryHelper.currencySymbolHelper(wallet.currency);
    final double stripeBalance =
        wallet.amountInConnectedAccount?.available ?? 0;

    return ShadowContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'your_balances'.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton.icon(
                onPressed: isRefreshing ? null : onRefreshTap,
                icon: isRefreshing
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh, size: 18),
                label: Text('refresh'.tr()),
                style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Two balance cards
          Row(
            children: <Widget>[
              Expanded(
                child: _BalanceCard(
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: AppColors.primaryColor,
                  title: 'wallet'.tr(),
                  amount:
                      '$symbol${wallet.withdrawableBalance.toStringAsFixed(2)}',
                  subtitle: 'available_to_transfer'.tr(),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _BalanceCard(
                  icon: null,
                  iconText: 'S',
                  iconColor: AppColors.secondaryColor,
                  title: 'stripe'.tr(),
                  amount: '$symbol${stripeBalance.toStringAsFixed(2)}',
                  subtitle: 'ready_to_withdraw'.tr(),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Currency and Updated row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'currency'.tr(args: <String>[wallet.currency]),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                'updated'.tr(args: <String>[_formatTime()]),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Stats row - simple text without boxes
          Wrap(
            children: <Widget>[
              _StatItem(
                label: 'pending'.tr(),
                value: wallet.pendingBalance,
                symbol: symbol,
                showInfoIcon: true,
              ),
              _StatItem(
                label: 'total_balance'.tr(),
                value: wallet.totalBalance,
                symbol: symbol,
              ),
              _StatItem(
                label: 'total_earned'.tr(),
                value: wallet.totalEarnings,
                symbol: symbol,
              ),
              _StatItem(
                label: 'withdrawn'.tr(),
                value: wallet.totalWithdrawn,
                symbol: symbol,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // Withdraw button
          SizedBox(
            width: double.infinity,
            child: CustomElevatedButton(
              isLoading: isWithdrawing,
              title: 'withdraw_funds'.tr(),
              onTap: onWithdrawTap,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Info text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.info_outline, size: 14, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(
                'two_step_process'.tr(),
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime() {
    final DateTime now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.title,
    required this.amount,
    required this.subtitle,
    required this.iconColor,
    this.icon,
    this.iconText,
  });

  final IconData? icon;
  final String? iconText;
  final Color iconColor;
  final String title;
  final String amount;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      padding: const EdgeInsets.all(AppSpacing.md),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              if (icon != null)
                Icon(icon, color: iconColor, size: 20)
              else if (iconText != null)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Center(
                    child: Text(
                      iconText!,
                      style: TextStyle(
                        color: iconColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            amount,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.symbol,
    this.showInfoIcon = false,
  });

  final String label;
  final double value;
  final String symbol;
  final bool showInfoIcon;

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      margin: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (showInfoIcon) ...<Widget>[
                const SizedBox(width: 2),
                Icon(Icons.info_outline, size: 12, color: Colors.blue[400]),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$symbol${value.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
