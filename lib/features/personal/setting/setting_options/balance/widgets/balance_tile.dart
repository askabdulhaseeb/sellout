import 'package:flutter/material.dart';

import '../../../../../../core/helper_functions/country_helper.dart';

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
    final String symbol = CountryHelper.currencySymbolHelper(currencyCode);
    final String valueStr = '$symbol${value.toDouble().toStringAsFixed(2)}';

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              valueStr,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
