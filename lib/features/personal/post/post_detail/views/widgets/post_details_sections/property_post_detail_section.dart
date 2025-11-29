import 'package:flutter/material.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../../domain/entities/post/post_entity.dart';
import '../post_detail_description_section.dart';
import '../post_detail_location_preview.dart';
import '../post_detail_property_key_feature_widget.dart';
import '../post_detail_seller_section.dart';
import '../reviews/post_detail_review_overview_section.dart';

class PropertyPostDetailSection extends StatelessWidget {
  const PropertyPostDetailSection({
    required this.post,
    super.key,
  });

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    AppLog.info('PostID: ${post.postID} ');
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PostDetailPropertyKeyFeaturesWidget(
            post: post,
          ),
          PostDetailDescriptionSection(post: post),
          PostDetailPropertyLocationLocationWidget(
              location: post.meetUpLocation),
          PostDetailSellerSection(post: post),
          PostDetailReviewOverviewSection(post: post),
        ],
      ),
    );
  }
}
