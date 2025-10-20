import 'package:flutter/material.dart';
import '../../../../../../../../core/functions/app_log.dart';
import '../../../../domain/entities/post/post_entity.dart';
import '../../../../feed/views/widgets/post/widgets/section/buttons/home_post_button_section.dart';
import '../post_detail_condition_delivery_detail.dart';
import '../post_detail_description_section.dart';
import '../post_detail_seller_section.dart';
import '../post_detail_title_amount_section.dart';
import '../post_vehicle_detail_widget.dart';
import '../reviews/post_detail_review_overview_section.dart';

class VehiclePostDetailSection extends StatelessWidget {
  const VehiclePostDetailSection({
    required this.post,
    super.key,
  });

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    AppLog.info('PostID: ${post.postID} ');
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        PostDetailTitleAmountSection(post: post),
        ConditionDeliveryWidget(post: post),
        PostButtonSection(
          detailWidget: true,
          post: post,
        ),
        PostVehicleDetailWidget(post: post),
        // PostPetDetailWidget(post: post),
        // PostDetailPropertyKeyFeaturesWidget(
        //   post: post,
        // ),
        PostDetailDescriptionSection(post: post),
        // const PostDetailSafetyTipsWidget(),
        // ReturnPosrtageAndExtraDetailsSection(post: post),
        // PostDetailPropertyLocationLocationWidget(location: post.meetUpLocation),
        PostDetailSellerSection(post: post),
        PostDetailReviewOverviewSection(post: post),
      ]),
    );
  }
}
