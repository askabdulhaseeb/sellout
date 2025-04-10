import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../data/sources/local/local_post.dart';
import '../../../domain/entities/post_entity.dart';
import '../../../domain/entities/visit/visiting_entity.dart';
import '../../../feed/views/widgets/post/widgets/section/buttons/home_post_button_section.dart';
import '../../../feed/views/widgets/post/widgets/section/buttons/type/post_button_for_user_tile.dart';
import '../providers/post_detail_provider.dart';
import '../widgets/condition_delivery_detail.dart';
import '../widgets/post_detail_attachment_slider.dart';
import '../widgets/post_detail_description_section.dart';
import '../widgets/post_detail_postage_return_section.dart';
import '../widgets/post_detail_return_policy_details.dart';
import '../widgets/post_rating_section.dart';
import '../widgets/reviews/post_detail_review_overview_section.dart';
import '../widgets/post_detail_title_amount_section.dart';
import '../widgets/sellout_bank_guranter_widget.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key});
  static const String routeName = '/post-detail';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String postID = args['pid'] ?? '';
    final VisitingEntity? visit = args['visit'] as VisitingEntity?;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 110,
        leading: TextButton.icon(
          style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant),
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.onSurfaceVariant),
          onPressed: () => Navigator.pop(context),
          label: Text('go_back'.tr()),
        ),
      ),
      body: FutureBuilder<DataState<PostEntity>>(
        future: Provider.of<PostDetailProvider>(context, listen: false)
            .getPost(postID),
        initialData: LocalPost().dataState(postID),
        builder: (
          BuildContext context,
          AsyncSnapshot<DataState<PostEntity>> snapshot,
        ) {
          final PostEntity? post =
              snapshot.data?.entity ?? LocalPost().post(postID);
          final bool isMe = post?.createdBy == (LocalAuth.uid ?? '-');
          return post == null
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      spacing: 4,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        PostDetailAttachmentSlider(urls: post.fileUrls),
                        PostDetailTitleAmountSection(post: post),
                        if (isMe == true)
                          PostButtonsForUser(visit: visit, post: post),
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
                        PostDetailPostageReturnSection(post: post),
                        const SelloutBankGuranterWidget(),
                        const ReturnPolicyDetails(),
                        // const UserMeetupSafetyGuildlineSection(),
                        PostDetailReviewOverviewSection(post: post),
                        const SizedBox(height: 200),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
