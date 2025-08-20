import 'package:flutter/material.dart';
import '../../../../../review/domain/entities/review_entity.dart';
import '../../../../../review/views/widgets/review_tile.dart';

class PostDetailReviewListSection extends StatelessWidget {
  const PostDetailReviewListSection({required this.reviews, super.key});
  final List<ReviewEntity> reviews;

  @override
  Widget build(BuildContext context) {
    final int reviewCount = reviews.isEmpty ? 0 : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (reviewCount > 0)
          Flexible(
            child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              padding: const EdgeInsets.all(0),
              itemCount: reviewCount,
              itemBuilder: (BuildContext context, int index) =>
                  ReviewTile(review: reviews[index]),
            ),
          ),
      ],
    );
  }
}
