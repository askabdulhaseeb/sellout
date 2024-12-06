import 'package:flutter/material.dart';

import '../../../../../../../../core/widgets/attachment_slider.dart';
import '../../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../domain/entities/post_entity.dart';
import '../../../../../post_detail/views/screens/post_detail_screen.dart';
import 'section/buttons/home_post_button_section.dart';
import 'section/home_post_header_section.dart';
import 'section/home_post_icon_botton_section.dart';
import 'section/home_post_title_section.dart';

class HomePostTile extends StatelessWidget {
  const HomePostTile({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child:
          // post.businessID == null && kDebugMode
          //     ? const SizedBox()
          //     :
          ShadowContainer(
        onTap: () {
          Navigator.of(context).pushNamed(
            PostDetailScreen.routeName,
            arguments: <String, dynamic>{'pid': post.postId},
          );
        },
        padding: const EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            PostHeaderSection(post: post),
            AttachmentsSlider(urls: post.fileUrls),
            HomePostIconBottonSection(post: post),
            HomePostTitleSection(post: post),
            PostButtonSection(post: post),
          ],
        ),
      ),
    );
  }
}
