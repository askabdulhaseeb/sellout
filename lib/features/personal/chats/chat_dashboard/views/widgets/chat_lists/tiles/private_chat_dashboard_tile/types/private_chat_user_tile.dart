import 'package:flutter/material.dart';
import '../../../../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../../../../core/sources/api_call.dart';
import '../../../../../../../../../../core/widgets/loaders/simple_tile_loader.dart';
import '../../../../../../../../../../services/get_it.dart';
import '../../../../../../../../user/profiles/data/models/user_model.dart';
import '../../../../../../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../../../../../../data/models/chat/chat_model.dart';
import '../../../../chat_profile_with_status.dart';
import '../../../../unseen_message_badge.dart';

class PrivateChatUserTile extends StatelessWidget {
  const PrivateChatUserTile({required this.chat, super.key});
  final ChatEntity chat;

  @override
  Widget build(BuildContext context) {
    final GetUserByUidUsecase getUserByUidUsecase =
        GetUserByUidUsecase(locator());
    return FutureBuilder<DataState<UserEntity?>>(
      future: getUserByUidUsecase.call(chat.otherPerson()),
      builder: (BuildContext context,
          AsyncSnapshot<DataState<UserEntity?>> snapshot) {
        final UserEntity? user = snapshot.data?.entity;
        if (user == null) {
          return const SimpleTileLoader();
        }
        return Row(
          children: <Widget>[
            ProfilePictureWithStatus(
              isProduct: false,
              postImageUrl: user.profilePhotoURL ?? '',
              userImageUrl: '',
              userDisplayName: user.displayName,
              userId: user.uid,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    user.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    chat.lastMessage?.displayText ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Text(
                  chat.lastMessage?.createdAt.timeAgo ?? '',
                  style: const TextStyle(fontSize: 10),
                ),
                UnreadMessageBadgeWidget(chatId: chat.chatId),
              ],
            ),
          ],
        );
      },
    );
  }
}
