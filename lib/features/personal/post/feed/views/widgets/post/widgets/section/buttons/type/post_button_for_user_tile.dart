import 'package:flutter/material.dart';
import '../../../../../../../../domain/entities/post/post_entity.dart';
import '../../../../../post_button_for_user/post_button_for_user_controller.dart';
import '../../../../../post_button_for_user/post_button_for_user_view.dart';

class PostButtonsForUser extends StatelessWidget {
  final PostEntity? post;
  const PostButtonsForUser({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    return PostButtonForUserView(
      post: post,
      controller: PostButtonForUserController(),
    );
  }
}
