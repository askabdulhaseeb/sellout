import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ServiceDetailCancellationPolicyWidget extends StatelessWidget {
  const ServiceDetailCancellationPolicyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('cancellations'.tr()),
        const SizedBox(
          height: 6,
        ),
        Text(
          'require_cancellation_fee'.tr(),
          style: TextTheme.of(context)
              .bodySmall
              ?.copyWith(color: ColorScheme.of(context).outline),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          'Cancel_appointment_before_two_hours'.tr(),
          style: TextTheme.of(context)
              .bodySmall
              ?.copyWith(color: ColorScheme.of(context).outline),
        ),
        const SizedBox(
          height: 6,
        ),
        Divider(
          color: ColorScheme.of(context).outlineVariant,
        )
      ],
    );
  }
}
