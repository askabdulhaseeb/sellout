import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/functions/app_log.dart';
import '../../../../../../listing/listing_form/views/providers/add_listing_form_provider.dart';
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

class GeneralPostDetailSection extends StatelessWidget {
  const GeneralPostDetailSection({
    required this.post,
    required this.isMe,
    required this.visit,
    super.key,
  });

  final PostEntity post;
  final bool isMe;
  final VisitingEntity? visit;

  @override
  Widget build(BuildContext context) {
    AppLog.info('PostID: ${post.postID} ');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          spacing: 4,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PostDetailAttachmentSlider(
                attachments: post.fileUrls.isNotEmpty
                    ? post.fileUrls
                    : Provider.of<AddListingFormProvider>(context).attachments),
            PostDetailTitleAmountSection(post: post),
            if (isMe == true) PostButtonsForUser(visit: visit, post: post),
            if (isMe == false)
              PostButtonSection(
                post: post,
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
            PostRatingSection(
              post: post,
            ),
            ConditionDeliveryWidget(post: post),
            PostDetailDescriptionSection(post: post),
            // PostDetailTileListSection(post: post),
            ReturnPosrtageAndExtraDetailsSection(post: post),
            // const UserMeetupSafetyGuildlineSection(),
            PostDetailReviewOverviewSection(post: post),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }
}
