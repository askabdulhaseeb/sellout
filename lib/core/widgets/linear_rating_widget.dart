import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../features/personal/review/domain/entities/review_entity.dart';

class LinearRatingGraphWidget extends StatelessWidget {
  const LinearRatingGraphWidget({
    required this.reviews,
    required this.onTap,
    super.key,
  });
  final List<ReviewEntity> reviews;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Opacity(
          opacity: 0.6,
          child: Text(
            '${reviews.length} ${'global-reviews'.tr()}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 6),
        _LinearProgressTile(
          onTap: () => onTap(5),
          star: 5,
          percent: reviews.where((ReviewEntity e) => e.rating == 5).length *
              100 ~/
              reviews.length,
        ),
        _LinearProgressTile(
          onTap: () => onTap(4),
          star: 4,
          percent: reviews.where((ReviewEntity e) => e.rating == 4).length *
              100 ~/
              reviews.length,
        ),
        _LinearProgressTile(
          onTap: () => onTap(3),
          star: 3,
          percent: reviews.where((ReviewEntity e) => e.rating == 3).length *
              100 ~/
              reviews.length,
        ),
        _LinearProgressTile(
          onTap: () => onTap(2),
          star: 2,
          percent: reviews.where((ReviewEntity e) => e.rating == 2).length *
              100 ~/
              reviews.length,
        ),
        _LinearProgressTile(
          onTap: () => onTap(1),
          star: 1,
          percent: reviews.where((ReviewEntity e) => e.rating == 1).length *
              100 ~/
              reviews.length,
        ),
      ],
    );
  }
}

class _LinearProgressTile extends StatelessWidget {
  const _LinearProgressTile({
    required this.star,
    required this.percent,
    required this.onTap,
  });
  final int star;
  final int percent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Text('$star ${'star'.tr()}'),
            const SizedBox(width: 10),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: percent / 100,
                  minHeight: 24,
                  backgroundColor: Theme.of(context).dividerColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 40,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text('$percent%'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
