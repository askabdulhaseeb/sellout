import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../../../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../providers/chat_provider.dart';

class PrivateChatTitleWidget extends StatelessWidget {
  const PrivateChatTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (BuildContext context, ChatProvider pro, _) {
        final UserEntity? user =
            LocalUser().userEntity(pro.chat?.otherPerson() ?? '');
        return Row(
          children: <Widget>[
            ProfilePhoto(
              url: user?.profilePhotoURL,
              placeholder: user?.displayName ?? '',
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  user?.displayName ?? '',
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
