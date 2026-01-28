import 'package:flutter/material.dart';

class QuantityCounter extends StatelessWidget {
  const QuantityCounter({
    required this.quantity,
    required this.maxQuantity,
    required this.onChanged,
    super.key,
  });

  final int quantity;
  final int maxQuantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(4);
    final BoxDecoration decoration = BoxDecoration(
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      borderRadius: borderRadius,
    );

    return IntrinsicWidth(
      child: Row(
        children: <Widget>[
          InkWell(
            borderRadius: borderRadius,
            onTap: () {
              if (quantity > 1) {
                onChanged(quantity - 1);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: decoration,
              child: const Icon(Icons.remove),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: Center(
              child: Text(
                quantity.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          InkWell(
            borderRadius: borderRadius,
            onTap: () {
              if (quantity < maxQuantity) {
                onChanged(quantity + 1);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: decoration,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
