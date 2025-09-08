import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LocationHeader extends StatelessWidget {
  const LocationHeader(
      {required this.onReset, required this.onApply, super.key});
  final VoidCallback onReset;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TextButton(
          onPressed: () {
            onReset();
          },
          child: Text(
            'cancel'.tr(),
            style: TextTheme.of(context)
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          'location'.tr(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        TextButton(
          onPressed: () {
            onApply();
          },
          child: Text(
            'apply'.tr(),
            style: TextTheme.of(context)
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
        )
      ],
    );
  }
}
