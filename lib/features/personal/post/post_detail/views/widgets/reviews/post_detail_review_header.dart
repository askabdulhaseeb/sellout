import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/indicators/rating_display_widget.dart';
import '../../../../domain/entities/post/post_entity.dart';

class PostDetailRatingHeader extends StatelessWidget {
  const PostDetailRatingHeader({required this.post, super.key});

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 2,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'customer_reviews',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ).tr(),
        Row(
          children: <Widget>[
            RatingDisplayWidget(
              ratingList: post.listOfReviews ?? <double>[],
              displayPrefix: false,
              displayRating: false,
            ),
            const SizedBox(width: 4),
            RatingDisplayWidget(
              ratingColor: ColorScheme.of(context).onSurface,
              ratingList: post.listOfReviews ?? <double>[],
              displayStars: false,
              displayPrefix: false,
            ),
            Text('out_of_5'.tr()),
          ],
        ),
      ],
    );
  }
}
