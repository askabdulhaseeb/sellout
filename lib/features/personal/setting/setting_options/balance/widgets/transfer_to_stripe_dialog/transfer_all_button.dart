import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../core/widgets/shadow_container.dart';
class TransferAllButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final String symbol;
  final double walletBalance;
  const TransferAllButton({
    super.key,
    required this.onTap,
    required this.label,
    required this.symbol,
    required this.walletBalance,
  });

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      onTap: onTap,
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
            '$label ($symbol${walletBalance.toStringAsFixed(2)})',
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
