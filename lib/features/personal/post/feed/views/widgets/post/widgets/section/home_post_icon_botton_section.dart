import 'package:flutter/material.dart';
import '../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../domain/entities/post_entity.dart';
import 'icon_butoons/chat_with_seller_icon_button.dart';
import 'icon_butoons/save_post_icon_button.dart';
import 'icon_butoons/share_post_icon_button.dart';

class HomePostIconBottonSection extends StatelessWidget {
  const HomePostIconBottonSection({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    final bool isMine = post.createdBy == LocalAuth.uid;
    return Row(
      children: <Widget>[
        if (!isMine) ChatwithSellerIconButton(userId: post.createdBy),
        SharePostButton(
          post: post,
        ),
        const Spacer(),
        if (!isMine)
          SavePostIconButton(
            postId: post.postID,
          )
      ],
    );
  }
}
