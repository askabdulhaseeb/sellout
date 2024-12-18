import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/widgets/linear_rating_widget.dart';
import '../../../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../../../../../review/data/sources/local_review.dart';
import '../../../../../review/domain/entities/review_entity.dart';
import '../../../../../review/domain/param/get_review_param.dart';
import '../../../../../review/features/reivew_list/views/params/review_list_param.dart';
import '../../../../../review/features/reivew_list/views/screens/review_list_screen.dart';
import '../../../../domain/entities/post_entity.dart';
import '../../providers/post_detail_provider.dart';
import 'post_detail_review_attachment_list_widget.dart';
import 'post_detail_review_button_section.dart';
import 'post_detail_review_list_section.dart';

class PostDetailReviewOverviewSection extends StatelessWidget {
  const PostDetailReviewOverviewSection({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    final GetReviewParam param = GetReviewParam(
      id: post.createdBy,
      type: ReviewApiQueryOptionType.sellerID,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(
          'customer-reviews',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ).tr(),
        const SizedBox(height: 6),
        FutureBuilder<DataState<List<ReviewEntity>>>(
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
                  const PostDetailReviewAttachmentListWidget(),
                  const PostDetailReviewButtonSection(),
                  PostDetailReviewListSection(reviews: reviews),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
