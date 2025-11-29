import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../core/widgets/linear_rating_widget.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../review/data/sources/local_review.dart';
import '../../../../../review/domain/entities/review_entity.dart';
import '../../../../../review/domain/param/get_review_param.dart';
import '../../../../../review/views/params/review_list_param.dart';
import '../../../../../review/views/screens/review_list_screen.dart';
import '../../../../../review/views/screens/write_review_screen.dart';
import '../../../../domain/entities/post/post_entity.dart';
import '../../providers/post_detail_provider.dart';
import 'post_detail_review_attachment_list_widget.dart';
import 'post_detail_review_header.dart';
import 'post_detail_review_list_section.dart';

class PostDetailReviewOverviewSection extends StatefulWidget {
  const PostDetailReviewOverviewSection({required this.post, super.key});
  final PostEntity post;

  @override
  State<PostDetailReviewOverviewSection> createState() =>
      _PostDetailReviewOverviewSectionState();
}

class _PostDetailReviewOverviewSectionState
    extends State<PostDetailReviewOverviewSection> {
  @override
  Widget build(BuildContext context) {
    final GetReviewParam param = GetReviewParam(
      id: widget.post.postID,
      type: ReviewApiQueryOptionType.postID,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        PostDetailRatingHeader(post: widget.post),
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
                  PostDetailReviewListSection(
                    reviews: reviews,
                    // post: widget.post,
                  ),
                  const PostDetailReviewAttachmentListWidget(),
                  if (reviews.isNotEmpty)
                    CustomElevatedButton(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant),
                      bgColor: Colors.transparent,
                      title: 'see_all_reviews'.tr(),
                      isLoading: false,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<ReviewListScreen>(
                          builder: (BuildContext context) => ReviewListScreen(
                              param: ReviewListScreenParam(reviews: reviews)),
                        ),
                      ),
                    ),
                  if (LocalAuth.currentUser?.userID != widget.post.createdBy &&
                      LocalAuth.currentUser?.businessID !=
                          widget.post.createdBy)
                    CustomElevatedButton(
                        title: 'write_review'.tr(),
                        isLoading: false,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            WriteReviewScreen.routeName,
                            arguments: <String, PostEntity>{
                              'post': widget.post
                            },
                          );
                        }),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
