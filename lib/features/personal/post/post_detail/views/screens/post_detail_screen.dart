import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/attachment_slider.dart';
import '../../../data/sources/local/local_post.dart';
import '../../../domain/entities/post_entity.dart';
import '../../../feed/views/widgets/post/widgets/section/buttons/home_post_button_section.dart';
import '../../../feed/views/widgets/post/widgets/section/home_post_header_section.dart';
import '../providers/post_detail_provider.dart';
import '../widgets/post_detail_description_section.dart';
import '../widgets/post_detail_title_amount_section.dart';
import '../widgets/post_rating_section.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key});
  static const String routeName = '/post-detail';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String postID = args['pid'] ?? '';
    print('postID: $postID');
    return Scaffold(
      appBar: AppBar(title: const Text('post-details').tr()),
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
                        PostButtonSection(
                          post: post,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        PostDetailDescriptionSection(post: post),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
