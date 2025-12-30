import 'package:flutter/material.dart';

class AvailableBalanceText extends StatelessWidget {
  final String symbol;
  final double walletBalance;
  final String availableLabel;
  const AvailableBalanceText({
    super.key,
    required this.symbol,
    required this.walletBalance,
    required this.availableLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$availableLabel: $symbol${walletBalance.toStringAsFixed(2)}',
      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
    );
  }
}
