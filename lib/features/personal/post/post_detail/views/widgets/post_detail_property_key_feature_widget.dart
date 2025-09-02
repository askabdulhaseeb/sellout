import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/utilities/app_string.dart';
import '../../../../../../core/widgets/custom_svg_icon.dart';
import '../../../domain/entities/post_entity.dart';

class PostDetailPropertyKeyFeaturesWidget extends StatelessWidget {
  const PostDetailPropertyKeyFeaturesWidget({super.key, required this.post});
  final PostEntity post;
  @override
  Widget build(BuildContext context) {
    final Color iconColor = Theme.of(context).colorScheme.error;
    final TextStyle? titleStyle =
        Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            );
    final TextStyle? featureTextStyle = Theme.of(context)
        .textTheme
        .bodySmall
        ?.copyWith(fontWeight: FontWeight.w500);

    final List<_Feature> features = <_Feature>[
      _Feature(
          AppStrings.selloutPostDetailhomeIcon, '${post.propertyCategory}'),
      _Feature(AppStrings.selloutPostDetailTenureIcon, '${post.tenureType}'),
      _Feature(AppStrings.selloutPostDetailBedroomIcon,
          '${post.bedroom} ${'bedrooms'.tr()}'),
      _Feature(AppStrings.selloutPostDetailBathroomIcon,
          '${post.bathroom} ${'bathrooms'.tr()}'),
      const _Feature(AppStrings.selloutPostDetailGardenIcon, '***'),
      const _Feature(AppStrings.selloutPostDetailAreaIcon, '***** sq ft'),
    ];

    final double screenWidth = MediaQuery.of(context).size.width;
    const double horizontalPadding = 16 * 2;
    const double spacing = 12;

    // total width available for both items in a row
    final double availableWidth = screenWidth - horizontalPadding - spacing;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('key_features_title'.tr(), style: titleStyle),
          const SizedBox(height: 12),
          Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: List.generate(features.length, (int index) {
              final _Feature f = features[index];
              final double itemWidth = (index == 0 || index == 3 || index == 4)
                  ? availableWidth * 0.52
                  : availableWidth * 0.48;
              return Container(
                width: itemWidth,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomSvgIcon(assetPath: f.icon, color: iconColor),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        f.value,
                        style: featureTextStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _Feature {
  const _Feature(this.icon, this.value);
  final String icon;
  final String value;
}
