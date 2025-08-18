import 'package:flutter/material.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../../domain/entities/post_entity.dart';
import '../../../../domain/entities/visit/visiting_entity.dart';
import '../../../../feed/views/widgets/post/widgets/section/buttons/home_post_button_section.dart';
import '../post_detail_attachment_slider.dart';
import '../post_detail_description_section.dart';
import '../post_detail_postage_return_delivery.dart';
import '../post_detail_title_amount_section.dart';
import '../post_rating_section.dart';
import '../reviews/post_detail_review_overview_section.dart';
import '../post_property_detail_widget.dart';

class PropertyPostDetailSection extends StatelessWidget {
  const PropertyPostDetailSection({
    required this.post,
    required this.visit,
    super.key,
  });

  final PostEntity post;
  final List<VisitingEntity>? visit;

  @override
  Widget build(BuildContext context) {
    AppLog.info('PostID: ${post.postID} ');
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PostDetailAttachmentSlider(attachments: post.fileUrls),
          PostDetailTitleAmountSection(post: post),
          PostButtonSection(
            post: post,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostRatingSection(
                  post: post,
                ),
                PostPropertyDetailWidget(
                  post: post,
                ),
                PostDetailDescriptionSection(post: post),
                // PostDetailTileListSection(post: post),
                ReturnPosrtageAndExtraDetailsSection(post: post),
                // const UserMeetupSafetyGuildlineSection(),
                PostDetailReviewOverviewSection(post: post),
                const SizedBox(height: 200),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
