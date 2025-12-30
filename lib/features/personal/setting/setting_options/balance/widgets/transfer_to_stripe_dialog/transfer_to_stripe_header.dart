import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_spacings.dart';

class TransferToStripeHeader extends StatelessWidget {
  const TransferToStripeHeader({
    required this.onBack,
    required this.title,
    super.key,
  });

  final VoidCallback onBack;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: onBack,
          child: const Icon(Icons.arrow_back_ios, size: 20),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
