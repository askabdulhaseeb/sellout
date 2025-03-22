import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/attachment_slider.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/in_dev_mode.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../book_visit/view/screens/view_booking_screen.dart';
import '../../../data/sources/local/local_post.dart';
import '../../../domain/entities/post_entity.dart';
import '../../../domain/entities/visit/visiting_entity.dart';
import '../../../feed/views/widgets/post/widgets/section/buttons/home_post_button_section.dart';
import '../../../feed/views/widgets/post/widgets/section/buttons/type/post_button_for_user_tile.dart';
import '../../../feed/views/widgets/post/widgets/section/home_post_header_section.dart';
import '../providers/post_detail_provider.dart';
import '../widgets/post_detail_description_section.dart';
import '../widgets/post_detail_postage_return_section.dart';
import '../widgets/reviews/post_detail_review_overview_section.dart';
import '../widgets/post_detail_tile_list_section.dart';
import '../widgets/post_detail_title_amount_section.dart';
import '../widgets/post_rating_section.dart';
import '../widgets/sellout_bank_guranter_widget.dart';
import '../widgets/user_meetup_safety_guildline_section.dart';

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
      appBar: AppBar(title: const Text('post_details').tr()),
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
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        PostHeaderSection(post: post),
                        AttachmentsSlider(urls: post.fileUrls),
                        PostDetailTitleAmountSection(post: post),
                        PostRatingSection(post: post),
                        if (isMe == true)
                          PostButtonsForUser(visit: visit, post: post),
                        if (isMe == false)
                          PostButtonSection(
                            post: post,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        PostDetailDescriptionSection(post: post),
                        PostDetailTileListSection(post: post),
                        PostDetailPostageReturnSection(post: post),
                        const SelloutBankGuranterWidget(),
                        const UserMeetupSafetyGuildlineSection(),
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
