import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/utilities/app_string.dart';
import '../../../../../../core/widgets/custom_svg_icon.dart';
import '../../../domain/entities/post/post_entity.dart';

class PostDetailPropertyKeyFeaturesWidget extends StatelessWidget {
  const PostDetailPropertyKeyFeaturesWidget({required this.post, super.key});
  final PostEntity post;
  @override
  Widget build(BuildContext context) {
    final Color iconColor = Theme.of(context).colorScheme.error;
    final TextStyle? titleStyle = Theme.of(context).textTheme.titleMedium
        ?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        );
    final TextStyle? featureTextStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500);

    final List<_Feature> features = <_Feature>[
      _Feature(
        AppStrings.selloutPostDetailhomeIcon,
        '${post.propertyInfo?.propertyCategory}',
      ),
      _Feature(
        AppStrings.selloutPostDetailTenureIcon,
        '${post.propertyInfo?.tenureType}',
      ),
      _Feature(
        AppStrings.selloutPostDetailBedroomIcon,
        '${post.propertyInfo?.bedroom} ${'bedrooms'.tr()}',
      ),
      _Feature(
        AppStrings.selloutPostDetailBathroomIcon,
        '${post.propertyInfo?.bathroom} ${'bathrooms'.tr()}',
      ),
    ];

    final double screenWidth = MediaQuery.of(context).size.width;
    const double horizontalPadding = 16 * 2;
    const double spacing = 12;

    // Two-column fixed-width layout: total available minus inter-item spacing
    final double availableWidth = screenWidth - horizontalPadding - spacing;
    final double itemWidth = availableWidth / 2;
    const double itemHeight = 48;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('key_features_title'.tr(), style: titleStyle),
        const SizedBox(height: 12),
        Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(features.length, (int index) {
            final _Feature f = features[index];
            return Container(
              width: itemWidth,
              height: itemHeight,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CustomSvgIcon(assetPath: f.icon, color: iconColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      f.value,
                      style: featureTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _Feature {
  const _Feature(this.icon, this.value);
  final String icon;
  final String value;
}
