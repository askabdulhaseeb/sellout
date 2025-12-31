import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_spacings.dart';

class TransferDialogHeader extends StatelessWidget {
  const TransferDialogHeader({
    required this.title,
    this.onBack,
    super.key,
  });

  final VoidCallback? onBack;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: onBack,
          child: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: onBack == null ? Theme.of(context).disabledColor : null,
          ),
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
