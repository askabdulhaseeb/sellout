import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../../../../../chat_dashboard/domain/entities/chat/group/group_into_entity.dart';
import '../../../providers/chat_provider.dart';

class GroupChatTitleWidget extends StatelessWidget {
  const GroupChatTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (BuildContext context, ChatProvider pro, _) {
        final GroupInfoEntity? groupInfo = pro.chat?.groupInfo;
        return Row(
          children: <Widget>[
            ProfilePhoto(
              url: groupInfo?.groupThumbnailURL,
              placeholder: groupInfo?.title ?? '',
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  groupInfo?.title ?? '',
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
