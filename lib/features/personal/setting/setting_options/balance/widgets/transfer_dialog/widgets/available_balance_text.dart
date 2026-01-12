import 'package:flutter/material.dart';

class AvailableBalanceText extends StatelessWidget {
  const AvailableBalanceText({
    required this.symbol,
    required this.balance,
    required this.availableLabel,
    super.key,
  });

  final String symbol;
  final double balance;
  final String availableLabel;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$availableLabel: $symbol${balance.toStringAsFixed(2)}',
      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
    );
  }
}
