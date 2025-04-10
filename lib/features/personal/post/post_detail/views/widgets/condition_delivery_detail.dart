import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/post_entity.dart';

class ConditionDeliveryWidget extends StatelessWidget {
  const ConditionDeliveryWidget({
    required this.post, super.key,
  });

  final PostEntity? post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text.rich(TextSpan(children: <InlineSpan>[
          TextSpan(
              text: '''${'condition'.tr()}: ''',
              style: TextTheme.of(context).bodyMedium),
          TextSpan(
              text: post?.condition.code.tr(),
              style: TextTheme.of(context).titleMedium)
        ])),
        Text.rich(TextSpan(children: <InlineSpan>[
          TextSpan(
              text: '''${'delivery'.tr()}: ''',
              style: TextTheme.of(context).bodyMedium),
          TextSpan(
              text: post?.deliveryType.code.tr(),
              style: TextTheme.of(context).titleMedium)
        ])),
      ],
    );
  }
}
