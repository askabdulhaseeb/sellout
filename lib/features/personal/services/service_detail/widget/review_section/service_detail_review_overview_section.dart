import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/widgets/linear_rating_widget.dart';
import '../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../../post/post_detail/views/providers/post_detail_provider.dart';
import '../../../../post/post_detail/views/widgets/reviews/post_detail_review_attachment_list_widget.dart';
import '../../../../post/post_detail/views/widgets/reviews/post_detail_review_list_section.dart';
import '../../../../review/data/sources/local_review.dart';
import '../../../../review/domain/entities/review_entity.dart';
import '../../../../review/domain/param/get_review_param.dart';
import '../../../../review/views/params/review_list_param.dart';
import '../../../../review/views/screens/review_list_screen.dart';
import 'widgets/service_detail_review_header.dart';

class ServiceDetailReviewOverviewSection extends StatefulWidget {
  const ServiceDetailReviewOverviewSection({required this.service, super.key});
  final ServiceEntity service;

  @override
  State<ServiceDetailReviewOverviewSection> createState() =>
      _ServiceDetailReviewOverviewSectionState();
}

class _ServiceDetailReviewOverviewSectionState
    extends State<ServiceDetailReviewOverviewSection> {
  @override
  Widget build(BuildContext context) {
    final GetReviewParam param = GetReviewParam(
      id: widget.service.serviceID,
      type: ReviewApiQueryOptionType.serviceID,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ServiceDetailReviewHeader(service: widget.service),
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
