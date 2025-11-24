import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PostDetailSafetyTipsWidget extends StatelessWidget {
  const PostDetailSafetyTipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).primaryColor;
    final TextStyle? titleStyle = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(fontWeight: FontWeight.bold);
    final TextStyle? bulletTextStyle =
        Theme.of(context).textTheme.labelMedium?.copyWith(color: color);

    final List<String> tips = <String>[
      'safety_point_1',
      'safety_point_2',
      'safety_point_3',
      'safety_point_4',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('safety_matters_title'.tr(), style: titleStyle),
        const SizedBox(height: 8),
        ...tips.map(
          (String tip) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('• ', style: bulletTextStyle),
                Expanded(child: Text(tip.tr(), style: bulletTextStyle)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
