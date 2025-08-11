import 'package:flutter/material.dart';
import '../../../../../../../../core/functions/app_log.dart';
import '../../../../../domain/entities/post_entity.dart';
import '../../../../../domain/entities/visit/visiting_entity.dart';
import '../../../../../feed/views/widgets/post/widgets/section/buttons/home_post_button_section.dart';
import '../../../../../feed/views/widgets/post/widgets/section/buttons/type/post_button_for_user_tile.dart';
import '../../condition_delivery_detail.dart';
import '../../post_detail_attachment_slider.dart';
import '../../post_detail_description_section.dart';
import '../../post_detail_postage_return_delivery.dart';
import '../../post_detail_title_amount_section.dart';
import '../../post_rating_section.dart';
import '../../reviews/post_detail_review_overview_section.dart';
import 'widget/post_vehicle_detail_widget.dart';

class VehiclePostDetailSection extends StatelessWidget {
  const VehiclePostDetailSection({
    required this.post,
    required this.isMe,
    required this.visit,
    super.key,
  });

  final PostEntity post;
  final bool isMe;
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
          if (isMe == true) PostButtonsForUser(visit: visit, post: post),
          if (isMe == false)
            PostButtonSection(
              post: post,
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ConditionDeliveryWidget(post: post),
                PostRatingSection(
                  post: post,
                ),
                const Divider(),
                PostVehicleDetailWidget(post: post),
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
