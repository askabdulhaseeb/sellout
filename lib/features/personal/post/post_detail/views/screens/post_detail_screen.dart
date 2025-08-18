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
import '../widgets/post_detail_condition_delivery_detail.dart';
import '../widgets/post_detail_attachment_slider.dart';
import '../widgets/post_detail_description_section.dart';
import '../widgets/post_detail_postage_return_delivery.dart';
import '../widgets/post_detail_seller_section.dart';
import '../widgets/post_detail_title_amount_section.dart';
import '../widgets/reviews/post_detail_review_overview_section.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key});
  static const String routeName = '/product';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String postID = args['pid'] ?? '';
    final List<VisitingEntity>? visit = args['visit'];
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                Text('back'.tr()),
              ],
            ),
          ),
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
          final bool isMe =
              post?.createdBy == (LocalAuth.currentUser?.businessID ?? '-');
          return post == null
              ? const SizedBox()
              : SingleChildScrollView(
                  child: Column(children: <Widget>[
                    PostDetailAttachmentSlider(attachments: post.fileUrls),
                    PostDetailTitleAmountSection(post: post),
                    if (isMe == true)
                      PostButtonsForUser(visit: visit, post: post),
                    if (isMe == false)
                      PostButtonSection(
                        post: post,
                      ),
                    ConditionDeliveryWidget(post: post),
                    PostDetailDescriptionSection(post: post),
                    ReturnPosrtageAndExtraDetailsSection(post: post),
                    PostDetailSellerSection(post: post),
                    PostDetailReviewOverviewSection(post: post),
                  ]),
                );
        },
      ),
    );
  }
}
