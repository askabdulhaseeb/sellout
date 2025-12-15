import 'package:flutter/material.dart';

import 'balance_formatters.dart';

class BalanceTile extends StatelessWidget {
  const BalanceTile({
    required this.label,
    required this.value,
    required this.currencyCode,
    super.key,
  });

  final String label;
  final num value;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: <Widget>[
            Text(label, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              BalanceFormatters.formatAmount(value, currencyCode: currencyCode),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
