import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../core/widgets/shadow_container.dart';

class AmountInputSection extends StatelessWidget {
  const AmountInputSection({
    required this.controller,
    required this.currency,
    required this.maxAmount,
    this.onPercentageTap,
    super.key,
  });

  final TextEditingController controller;
  final String currency;
  final double maxAmount;
  final void Function(double)? onPercentageTap;

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                currency.toUpperCase(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(width: 1, height: 24, color: Colors.grey[300]),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[400],
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildPercentageButton('25%', 0.25),
              _buildPercentageButton('50%', 0.50),
              _buildPercentageButton('75%', 0.75),
              _buildPercentageButton('100%', 1.0),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPercentageButton(String label, double percentage) {
    return GestureDetector(
      onTap: onPercentageTap != null ? () => onPercentageTap!(percentage) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }
}
