import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/post/post_entity.dart';

class PostPropertyDetailWidget extends StatelessWidget {
  const PostPropertyDetailWidget({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Divider(),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          alignment: WrapAlignment.spaceBetween,
          children: <Widget>[
            PostPropertyDetailIconWidgets(
              icon: Icons.home_outlined,
              title: 'property_type'.tr(),
              value: post.propertyInfo?.propertyType ?? 'na'.tr(),
              showIcon: true,
            ),
            PostPropertyDetailIconWidgets(
              icon: Icons.bed_outlined,
              title: 'bedroom'.tr(),
              value: 'x${post.propertyInfo?.bedroom ?? '-'}',
              showIcon: true,
            ),
            PostPropertyDetailIconWidgets(
              icon: Icons.bathtub_outlined,
              title: 'bathroom'.tr(),
              value: 'x${post.propertyInfo?.bathroom ?? '-'}',
              showIcon: true,
            ),
            PostPropertyDetailIconWidgets(
              icon: Icons.info_outline,
              title: 'tenure'.tr(),
              value: post.propertyInfo?.tenureType ?? 'na'.tr(),
              showIcon: false, // no icon here
            ),
          ],
        ),
        const Divider(),
        // Key Features Heading
        Text('key_features'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        // Features in two columns
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 6,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 12,
              children: <Widget>[
                Expanded(
                  child: _featureItem(context,
                      '${post.propertyInfo?.bedroom} ${'bedrooms'.tr()}', true),
                ),
                Expanded(
                  child: _featureItem(
                      context,
                      '${post.propertyInfo?.bathroom} ${'bathrooms'.tr()}',
                      true),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 12,
              children: <Widget>[
                Expanded(
                  child: _featureItem(context, 'Parking area',
                      post.propertyInfo?.parking ?? false),
                ),
                Expanded(
                  child: _featureItem(
                      context, 'Garden', post.propertyInfo?.garden ?? false),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 12,
              children: <Widget>[
                Expanded(
                  child: _featureItem(context,
                      post.propertyInfo?.tenureType ?? 'na'.tr(), true),
                ),
                Expanded(
                  child: _featureItem(context, 'Viewings Available', true),
                ),
              ],
            ),
            _featureItem(
                context,
                'Located on ${post.meetUpLocation?.address ?? 'na'.tr()}',
                true),
            _featureItem(
                context,
                '${'energy_rating'.tr()}: ${post.propertyInfo?.energyRating}',
                true),
          ],
        ),
      ],
    );
  }

  Widget _featureItem(BuildContext context, String text, bool show) {
    return show
        ? SizedBox(
            child: Text(text,
                style: TextTheme.of(context)
                    .labelMedium
                    ?.copyWith(color: ColorScheme.of(context).outline)),
          )
        : const SizedBox.shrink();
  }
}

class PostPropertyDetailIconWidgets extends StatelessWidget {
  const PostPropertyDetailIconWidgets({
    required this.icon,
    required this.title,
    required this.value,
    super.key,
    this.showIcon = true,
  });
  final IconData icon;
  final String title;
  final String value;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextTheme.of(context)
                .bodySmall
                ?.copyWith(color: ColorScheme.of(context).outline),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (showIcon)
                const Icon(CupertinoIcons.home, size: 20, color: Colors.black),
              if (showIcon) const SizedBox(width: 4),
              Text(
                value,
                style: TextTheme.of(context).bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
