import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../../../../../../post/data/sources/local/local_post.dart';
import '../../../../../../post/domain/entities/post_entity.dart';
import '../../../../../../user/profiles/data/sources/local/local_user.dart';
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
            ProfilePhoto(
              url: post?.imageURL,
              placeholder: user?.displayName ?? '',
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  post?.title ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Opacity(
                  opacity: 0.5,
                  child: const Text(
                    'tap-here-to-open-profile',
                    style: TextStyle(fontSize: 12),
                  ).tr(),
                )
              ],
            )
          ],
        );
      },
    );
  }
}
