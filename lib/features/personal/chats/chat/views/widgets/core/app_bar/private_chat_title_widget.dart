import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../../chat_dashboard/views/widgets/chat_profile_with_status.dart';
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
            ProfilePictureWithStatus(
              isProduct: false,
              postImageUrl: user?.profilePhotoURL ?? user?.displayName ?? '',
              userImageUrl: '',
              userDisplayName: user?.displayName ?? '',
              userId: user?.uid ?? '',
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
                    'tap_here_to_open_profile',
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
