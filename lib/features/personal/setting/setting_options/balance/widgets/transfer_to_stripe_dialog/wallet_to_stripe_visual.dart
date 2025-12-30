import 'package:flutter/material.dart';

class WalletToStripeVisual extends StatelessWidget {
  const WalletToStripeVisual({
    required this.walletLabel,
    required this.stripeLabel,
    required this.walletColor,
    required this.stripeColor,
    required this.walletIcon,
    required this.stripeIconText,
    super.key,
  });
  final String walletLabel;
  final String stripeLabel;
  final Color walletColor;
  final Color stripeColor;
  final IconData walletIcon;
  final String stripeIconText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildIconBox(icon: walletIcon, label: walletLabel, color: walletColor),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(width: 30, height: 2, color: Colors.grey[300]),
        ),
        _buildIconBox(
          iconText: stripeIconText,
          label: stripeLabel,
          color: stripeColor,
        ),
      ],
    );
  }

  Widget _buildIconBox({
    required String label,
    required Color color,
    IconData? icon,
    String? iconText,
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
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
