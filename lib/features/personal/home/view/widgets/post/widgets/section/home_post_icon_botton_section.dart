import 'package:flutter/material.dart';
import '../../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../../core/widgets/custom_svg_icon.dart';
import '../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../post/domain/entities/post/post_entity.dart';
import 'icon_butoons/post_inquiry_buttons.dart';
import 'icon_butoons/save_post_icon_button.dart';
import 'icon_butoons/share_post_icon_button.dart';

class HomePostIconBottonSection extends StatelessWidget {
  const HomePostIconBottonSection({required this.post, this.isPreview = false, super.key});
  final PostEntity post;
  final bool isPreview;
  @override
  Widget build(BuildContext context) {
    final bool isMine = post.createdBy == LocalAuth.uid;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: <Widget>[
          if (!isMine || isPreview) CreatePostInquiryChatButton(post: post),
          SharePostButton(
            tappableWidget:
                const CustomSvgIcon(assetPath: AppStrings.selloutShareIcon),
            postId: post.postID,
          ),
          const Spacer(),
          if (!isMine || isPreview)
            SavePostIconButton(
              postId: post.postID,
            )
        ],
      ),
    );
  }
}
