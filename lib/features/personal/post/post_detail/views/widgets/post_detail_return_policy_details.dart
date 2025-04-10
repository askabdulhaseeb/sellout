import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ReturnPolicyDetails extends StatelessWidget {
  const ReturnPolicyDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'cancel_within'.tr(),
          style: const TextStyle(fontSize: 14),
        ).tr(),
        Text(
          '30' '${'days'.tr()}',
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ).tr(),
        const SizedBox(
          height: 4,
        ),
        Text(
          'return_postage'.tr(),
          style: const TextStyle(fontSize: 14),
        ).tr(),
        Text(
          'buyer_pay_for_return'.tr(),
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ).tr(),
        const Divider(),
        RichText(
            text: TextSpan(
                style: TextTheme.of(context).bodyMedium,
                children: <InlineSpan>[
              TextSpan(text: 'refer_to'.tr()),
              TextSpan(
                  text: 'return_policy'.tr(),
                  style: TextTheme.of(context).bodyMedium?.copyWith(
                      decoration: TextDecoration.underline,
                      color: Colors.blue)),
              TextSpan(text: 'for_more_details_covered_by'.tr()),
              TextSpan(
                  text: 'money_gaurantee'.tr(),
                  style: TextTheme.of(context).bodyMedium?.copyWith(
                      color: Colors.blue,
                      decoration: TextDecoration.underline)),
              TextSpan(text: 'if_recieve_wrong_item'.tr())
            ])),
        const SizedBox(
          height: 6,
        ),
        Text('buyer_not_pay'.tr(),
            style: TextTheme.of(context).bodyMedium?.copyWith(
                  color: Theme.of(context).hintColor,
                )),
        const Divider(),
        Text('retrun_policy_details'.tr(),
            style: TextTheme.of(context)
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500)),
        Text('return_accepted_in_30_days'.tr(),
            style: TextTheme.of(context)
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w500)),
        Text('find_buyer_rights'.tr(),
            style: TextTheme.of(context).bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                )),
        const Divider(),
      ],
    );
  }
}
