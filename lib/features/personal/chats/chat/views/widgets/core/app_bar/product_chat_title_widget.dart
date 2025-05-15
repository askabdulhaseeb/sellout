import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../post/data/sources/local/local_post.dart';
import '../../../../../../post/domain/entities/post_entity.dart';
import '../../../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../../chat_dashboard/views/widgets/chat_profile_with_status.dart';
import '../../../providers/chat_provider.dart';

class ProductChatTitleWidget extends StatelessWidget {
  const ProductChatTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (BuildContext context, ChatProvider pro, _) {
        final UserEntity? user =
            LocalUser().userEntity(pro.chat?.otherPerson() ?? '');
        final PostEntity? post =
            LocalPost().post(pro.chat?.productInfo?.id ?? '');
        return Row(
          children: <Widget>[
            ProfilePictureWithStatus(
              isProduct: true,
              postImageUrl: post?.imageURL ?? '',
              userImageUrl: user?.profilePhotoURL ?? user?.displayName ?? '',
              userDisplayName: user?.displayName ?? post?.title ?? '',
              userId: user?.uid ?? '',
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    post?.title ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: const Text(
                      'tap_here_to_open_profile',
                      style: TextStyle(fontSize: 12),
                    ).tr(),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
