import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/indicators/linear_rating_widget.dart';
import '../../../../../personal/post/post_detail/views/providers/post_detail_provider.dart';
import '../../../../../personal/post/post_detail/views/widgets/reviews/post_detail_review_list_section.dart';
import '../../../../../personal/review/data/sources/local_review.dart';
import '../../../../../personal/review/domain/entities/review_entity.dart';
import '../../../../../personal/review/domain/param/get_review_param.dart';
import '../../../../../personal/review/views/params/review_list_param.dart';
import '../../../../../personal/review/views/screens/review_list_screen.dart';
import '../../../../core/domain/entity/business_entity.dart';

class BusinessPageReviewSection extends StatelessWidget {
  const BusinessPageReviewSection({required this.business, super.key});
  final BusinessEntity business;

  @override
  Widget build(BuildContext context) {
    final GetReviewParam param = GetReviewParam(
      id: business.businessID ?? '',
      type: ReviewApiQueryOptionType.businessID,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FutureBuilder<DataState<List<ReviewEntity>>>(
        future: Provider.of<PostDetailProvider>(context, listen: false)
            .getReviews(param),
        initialData: LocalReview().dataState(param),
        builder: (
          BuildContext context,
          AsyncSnapshot<DataState<List<ReviewEntity>>> snapshot,
        ) {
          final List<ReviewEntity> reviews =
              snapshot.data?.entity ?? LocalReview().reviewsWithQuery(param);

          return SingleChildScrollView(
            primary: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                LinearRatingGraphWidget(
                  reviews: reviews,
                  onTap: (int value) {
                    Navigator.of(context).push(
                      MaterialPageRoute<ReviewListScreen>(
                        builder: (BuildContext context) => ReviewListScreen(
                          param: ReviewListScreenParam(
                            reviews: reviews,
                            star: value,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                PostDetailReviewListSection(reviews: reviews),
              ],
            ),
          );
        },
      ),
    );
  }
}
