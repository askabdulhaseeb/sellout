import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../review/domain/entities/review_entity.dart';
import '../../../../../review/features/reivew_list/views/params/review_list_param.dart';
import '../../../../../review/features/reivew_list/views/screens/review_list_screen.dart';
import '../../../../../review/features/reivew_list/views/widgets/review_tile.dart';

class PostDetailReviewListSection extends StatelessWidget {
  const PostDetailReviewListSection({required this.reviews, super.key});
  final List<ReviewEntity> reviews;

  @override
  Widget build(BuildContext context) {
    final int reviewCount = reviews.length > 5 ? 5 : reviews.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
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
        CustomElevatedButton(
          border: Border.all(color: Theme.of(context).disabledColor),
          bgColor: Colors.transparent,
          title: 'see-all-reviews'.tr(),
          isLoading: false,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<ReviewListScreen>(
              builder: (BuildContext context) => ReviewListScreen(
                  param: ReviewListScreenParam(reviews: reviews)),
            ),
          ),
        ),
      ],
    );
  }
}
