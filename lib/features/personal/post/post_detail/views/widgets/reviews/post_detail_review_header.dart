import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/rating_display_widget.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../review/views/screens/write_review_screen.dart';
import '../../../../domain/entities/post_entity.dart';

class PostDetailRatingHeader extends StatelessWidget {
  const PostDetailRatingHeader({
    required this.post,
    super.key,
  });

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'customer_reviews',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ).tr(),
        const SizedBox(height: 2),
        Row(
          children: <Widget>[
            RatingDisplayWidget(
              ratingList: post.listOfReviews ?? <double>[],
              displayPrefix: false,
              displayRating: false,
            ),
            const SizedBox(
              width: 4,
            ),
            RatingDisplayWidget(
              ratingList: post.listOfReviews ?? <double>[],
              displayStars: false,
              displayPrefix: false,
            ),
            Text('out_of_5'.tr()),
            const Spacer(),
            if (LocalAuth.currentUser?.userID != post.createdBy &&
                LocalAuth.currentUser?.businessID != post.createdBy)
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      WriteReviewScreen.routeName,
                      arguments: <String, PostEntity>{'post': post},
                    );
                  },
                  child: Text(
                    'write_review'.tr(),
                    style: TextStyle(
                        decorationColor: Theme.of(context).primaryColor,
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).primaryColor),
                  ))
          ],
        ),
      ],
    );
  }
}
