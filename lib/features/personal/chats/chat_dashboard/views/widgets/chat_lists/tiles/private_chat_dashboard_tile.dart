import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../../core/widgets/loader.dart';
import '../../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../services/get_it.dart';
import '../../../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../../../business/core/domain/usecase/get_business_by_id_usecase.dart';
import '../../../../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../../../../../../user/profiles/data/models/user_model.dart';
import '../../../../../chat/views/providers/chat_provider.dart';
import '../../../../../chat/views/screens/chat_screen.dart';
import '../../../../data/sources/local/local_unseen_messages.dart';
import '../../../../domain/entities/chat/chat_entity.dart';
import '../../chat_profile_with_status.dart';
import '../../unseen_message_badge.dart';

class PrivateChatDashboardTile extends StatelessWidget {
  const PrivateChatDashboardTile({required this.chat, super.key});
  final ChatEntity chat;

  @override
  Widget build(BuildContext context) {
    final ChatProvider pro = Provider.of<ChatProvider>(context, listen: false);
    final bool isBusiness = chat.otherPerson().startsWith('BU');

    return GestureDetector(
      onTap: () async {
        pro.setChat(chat);
        await LocalUnreadMessagesService().clearCount(chat.chatId);
        Navigator.of(context).pushNamed(ChatScreen.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          children: <Widget>[
            isBusiness
                ? PrivateChatBusinessTile(chat: chat)
                : PrivateChatUserTile(chat: chat),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

class PrivateChatBusinessTile extends StatelessWidget {
  const PrivateChatBusinessTile({required this.chat, super.key});
  final ChatEntity chat;

  @override
  Widget build(BuildContext context) {
    final GetBusinessByIdUsecase getBusinessByIdUsecase =
        GetBusinessByIdUsecase(locator());

    return FutureBuilder<DataState<BusinessEntity?>>(
      future: getBusinessByIdUsecase.call(chat.otherPerson()),
      builder: (BuildContext context,
          AsyncSnapshot<DataState<BusinessEntity?>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        final DataState<BusinessEntity?>? dataState = snapshot.data;
        if (dataState == null || dataState.entity == null) {
          return Text(dataState?.exception?.message ?? 'user_not_found'.tr());
        }

        final BusinessEntity business = dataState.entity!;
        return Row(
          children: <Widget>[
            ProfilePictureWithStatus(
              isProduct: false,
              postImageUrl: business.logo?.url ?? 'na',
              userImageUrl: '',
              userDisplayName: business.displayName ?? 'na',
              userId: business.businessID ?? 'na',
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    business.displayName ?? '',
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        final DataState<UserEntity?>? dataState = snapshot.data;
        if (dataState == null || dataState.entity == null) {
          return Text(dataState?.exception?.message ?? 'user_not_found'.tr());
        }

        final UserEntity user = dataState.entity!;
        return Row(
          children: <Widget>[
            ProfilePictureWithStatus(
              isProduct: false,
              postImageUrl: user.profilePhotoURL ?? user.displayName,
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
