import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/rating_display_widget.dart';
import '../../../domain/entities/post_entity.dart';

class PostRatingSection extends StatelessWidget {
  const PostRatingSection({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        spacing: 4,
        children: <Widget>[
          RatingDisplayWidget(
            ratingList: post.listOfReviews ?? <double>[],
            displayStars: false,
            displayPrefix: false,
          ),
          Icon(
            CupertinoIcons.star_fill,
            size: 14,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
