import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../domain/entities/post/post_entity.dart';
import 'post_rating_section.dart';

class ConditionDeliveryWidget extends StatelessWidget {
  const ConditionDeliveryWidget({
    required this.post,
    super.key,
  });

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        spacing: 6,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              PostRatingSection(post: post),
              if (post.listID == ListingType.items.json ||
                  post.listID == ListingType.clothAndFoot.json ||
                  post.listID == ListingType.vehicle.json ||
                  post.listID == ListingType.property.json)
                _buildInfoItem(
                  context,
                  iconColor: colorScheme.outlineVariant,
                  label: 'condition'.tr(),
                  value: post.condition.code.tr(),
                ),
              if (post.listID == ListingType.items.json ||
                  post.listID == ListingType.clothAndFoot.json ||
                  post.listID == ListingType.foodAndDrink.json ||
                  post.listID == ListingType.pets.json ||
                  post.listID == ListingType.vehicle.json)
                _buildInfoItem(
                  context,
                  iconColor: colorScheme.outlineVariant,
                  label: 'delivery'.tr(),
                  value: post.deliveryType.code.tr(),
                ),
            ],
          ),
          // if (post.listID == ListingType.items.json)
          //   Text(
          //     '${'return'.tr()}: dummy data',
          //     style:
          //         textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          //   ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context,
      {required Color iconColor,
      required String label,
      required String value}) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(Icons.circle, size: 8, color: iconColor),
        const SizedBox(width: 6),
        ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: screenWidth * 0.25), // Responsive width
          child: Text.rich(
            TextSpan(
              children: <InlineSpan>[
                TextSpan(
                  text: '$label: ',
                  style: textTheme.labelSmall
                      ?.copyWith(color: colorScheme.outline),
                ),
                TextSpan(
                  text: value,
                  style: textTheme.bodySmall?.copyWith(
                    overflow: TextOverflow.ellipsis,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
