import 'package:flutter/material.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../../domain/entities/post_entity.dart';
import '../../../../feed/views/widgets/post/widgets/section/buttons/home_post_button_section.dart';
import '../post_detail_condition_delivery_detail.dart';
import '../post_detail_attachment_slider.dart';
import '../post_detail_description_section.dart';
import '../post_detail_postage_return_delivery.dart';
import '../post_detail_safety_tips_widget.dart';
import '../post_detail_seller_section.dart';
import '../post_detail_title_amount_section.dart';
import '../reviews/post_detail_review_overview_section.dart';

class FoodDrinkPostDetailSection extends StatelessWidget {
  const FoodDrinkPostDetailSection({
    required this.post,
    super.key,
  });
  final PostEntity post;
  @override
  Widget build(BuildContext context) {
    AppLog.info('PostID: ${post.postID} ');
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        PostDetailAttachmentSlider(attachments: post.fileUrls),
        PostDetailTitleAmountSection(post: post),
        ConditionDeliveryWidget(post: post),
        PostButtonSection(
          detailWidget: true,
          post: post,
        ),
        PostDetailDescriptionSection(post: post),
        const PostDetailSafetyTipsWidget(),
        ReturnPosrtageAndExtraDetailsSection(post: post),
        PostDetailSellerSection(post: post),
        PostDetailReviewOverviewSection(post: post),
      ]),
    );
  }
}
