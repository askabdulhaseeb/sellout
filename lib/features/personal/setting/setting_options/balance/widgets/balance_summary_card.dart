import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../payment/data/sources/local/local_wallet.dart';
import '../provider/wallet_provider.dart';
import 'transfer_dialog/transfer_dialog.dart';
import 'withdraw_funds_dialog/withdraw_funds_dialog.dart';
import '../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/shadow_container.dart';
import '../../../../../../core/constants/app_spacings.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../payment/domain/entities/wallet_entity.dart';

class BalanceSummaryCard extends StatelessWidget {
  const BalanceSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
      builder: (BuildContext context, WalletProvider provider, Widget? child) {
        final WalletEntity? wallet = LocalWallet().getWallet();
        final String symbol = CountryHelper.currencySymbolHelper(
          wallet?.currency ?? '',
        );

        final bool isWithdrawing = provider.isProcessing;
        final bool isRefreshing = provider.refreshing;
        final double stripeBalance =
            wallet?.amountInConnectedAccount?.available ?? 0;

        return ShadowContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _HeaderSection(provider: provider, isRefreshing: isRefreshing),
              const SizedBox(height: AppSpacing.sm),
              _BalancesSection(
                symbol: symbol,
                wallet: wallet,
                stripeBalance: stripeBalance,
              ),
              const SizedBox(height: AppSpacing.md),
              _CurrencyUpdatedSection(
                currency: wallet?.currency ?? '',
                updatedAt: _formatTime(),
              ),
              const SizedBox(height: AppSpacing.md),
              _StatsSection(symbol: symbol, wallet: wallet),
              const SizedBox(height: AppSpacing.lg),
              _WithdrawSection(
                provider: provider,
                wallet: wallet,
                stripeBalance: stripeBalance,
                isWithdrawing: isWithdrawing,
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
      },
    );
  }
}

String _formatTime() {
  final DateTime now = DateTime.now();
  return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.provider, required this.isRefreshing});
  final WalletProvider provider;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'your_balances'.tr(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        TextButton.icon(
          onPressed: provider.refreshing
              ? null
              : () => provider.fetchWallet(isRefresh: true),
          icon: provider.refreshing
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
    );
  }
}

class _BalancesSection extends StatelessWidget {
  const _BalancesSection({
    required this.symbol,
    required this.wallet,
    required this.stripeBalance,
  });
  final String symbol;
  final WalletEntity? wallet;
  final double stripeBalance;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: _BalanceCard(
              icon: Icons.account_balance_wallet_outlined,
              iconColor: AppColors.primaryColor,
              title: 'wallet'.tr(),
              amount:
                  '$symbol${(wallet?.withdrawableBalance ?? 0).toStringAsFixed(2)}',
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
    );
  }
}

class _CurrencyUpdatedSection extends StatelessWidget {
  const _CurrencyUpdatedSection({
    required this.currency,
    required this.updatedAt,
  });
  final String currency;
  final String updatedAt;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'currency'.tr(args: <String>[currency]),
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        Text(
          'updated'.tr(args: <String>[updatedAt]),
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection({required this.symbol, required this.wallet});
  final String symbol;
  final WalletEntity? wallet;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _StatItem(
            label: 'pending'.tr(),
            value: wallet?.pendingBalance ?? 0,
            symbol: symbol,
            showInfoIcon: true,
          ),
        ),
        Expanded(
          child: _StatItem(
            label: 'total_balance'.tr(),
            value: wallet?.totalBalance ?? 0,
            symbol: symbol,
          ),
        ),
        Expanded(
          child: _StatItem(
            label: 'total_earned'.tr(),
            value: wallet?.totalEarnings ?? 0,
            symbol: symbol,
          ),
        ),
        Expanded(
          child: _StatItem(
            label: 'withdrawn'.tr(),
            value: wallet?.totalWithdrawn ?? 0,
            symbol: symbol,
          ),
        ),
      ],
    );
  }
}

class _WithdrawSection extends StatelessWidget {
  const _WithdrawSection({
    required this.provider,
    required this.wallet,
    required this.stripeBalance,
    required this.isWithdrawing,
  });
  final WalletProvider provider;
  final WalletEntity? wallet;
  final double stripeBalance;
  final bool isWithdrawing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomElevatedButton(
        isLoading: isWithdrawing,
        title: 'withdraw_funds'.tr(),
        onTap: () {
          if (isWithdrawing) return;
          WithdrawFundsDialog.show(
            context: context,
            walletBalance: provider.walletBalance,
            stripeBalance: provider.stripeBalance,
            currency: provider.currency,
            onTransferToStripe: () {
              Navigator.of(context).pop();
              TransferDialog.show(
                context: context,
                mode: TransferDialogMode.walletToStripe,
              ).then((_) => provider.resetTransferState());
            },
            onWithdrawToBank: () {
              Navigator.of(context).pop();
              TransferDialog.show(
                context: context,
                mode: TransferDialogMode.stripeToBank,
              ).then((_) => provider.resetTransferState());
            },
          );
        },
      ),
    );
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
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              amount,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          // const SizedBox(height: AppSpacing.xs),
          // Text(
          //   subtitle,
          //   style: TextStyle(color: Colors.grey[500], fontSize: 8),
          // ),
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
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              '$symbol${value.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
