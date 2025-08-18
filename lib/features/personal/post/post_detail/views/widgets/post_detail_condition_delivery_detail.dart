import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../domain/entities/post_entity.dart';
import 'post_rating_section.dart';

class ConditionDeliveryWidget extends StatelessWidget {
  const ConditionDeliveryWidget({
    required this.post,
    super.key,
  });

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        spacing: 6,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 8,
            children: <Widget>[
              PostRatingSection(post: post),
              Icon(Icons.circle,
                  size: 8, color: ColorScheme.of(context).outlineVariant),
              Text.rich(
                maxLines: 1,
                TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '${'condition'.tr()}: ',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: ColorScheme.of(context).outline),
                  ),
                  TextSpan(
                    text: post.condition.code.tr(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        overflow: TextOverflow.ellipsis,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
              Icon(Icons.circle,
                  size: 8, color: ColorScheme.of(context).outlineVariant),
              Text.rich(
                maxLines: 1,
                TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: '${'delivery'.tr()}: ',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: ColorScheme.of(context).outline),
                  ),
                  TextSpan(
                    text: post.deliveryType.code.tr(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        overflow: TextOverflow.ellipsis,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
            ],
          ),
          Text(
            '${'return'.tr()}:${'dummy data'}',
            style: TextTheme.of(context)
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
