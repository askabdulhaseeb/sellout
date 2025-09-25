import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../core/sources/api_call.dart';
import '../../../../../../../core/widgets/empty_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../services/get_it.dart';
import '../../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../../business/core/domain/usecase/get_business_by_id_usecase.dart';
import '../../../../../user/profiles/domain/entities/user_entity.dart';
import '../../../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../../../../chat/views/providers/chat_provider.dart';
import '../../../../chat/views/screens/chat_screen.dart';
import '../../../data/models/chat/chat_model.dart';
import '../../../data/sources/local/local_unseen_messages.dart';
import '../../providers/chat_dashboard_provider.dart';
import '../chat_profile_with_status.dart';
import '../unseen_message_badge.dart';

class ServicesChatListWidget extends StatelessWidget {
  const ServicesChatListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatDashboardProvider provider =
        context.watch<ChatDashboardProvider>();
    final List<ChatEntity> filteredChats = provider.filteredChats;

    if (filteredChats.isEmpty) {
      return Center(
        child: EmptyPageWidget(
          icon: CupertinoIcons.chat_bubble_2,
          childBelow: Text(
            'no_chats_found'.tr(),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        separatorBuilder: (BuildContext context, int index) => Container(
          height: 1,
          color: Theme.of(context).dividerColor,
          margin: const EdgeInsets.symmetric(vertical: 8),
        ),
        itemCount: filteredChats.length,
        itemBuilder: (BuildContext context, int index) {
          final ChatEntity chat = filteredChats[index];
          return ServiceChatDashboardTile(chat: chat);
        },
      ),
    );
  }
}

class ServiceChatDashboardTile extends HookWidget {
  const ServiceChatDashboardTile({required this.chat, super.key});
  final ChatEntity chat;

  @override
  Widget build(BuildContext context) {
    final ChatProvider pro = Provider.of<ChatProvider>(context, listen: false);
    final GetUserByUidUsecase getUserByUidUsecase =
        GetUserByUidUsecase(locator());
    final GetBusinessByIdUsecase getBusinessByIdUsecase =
        GetBusinessByIdUsecase(locator());
    final String otherId = chat.otherPerson();

    return GestureDetector(
      onTap: () async {
        pro.setChat(context, chat);
        await LocalUnreadMessagesService().clearCount(chat.chatId);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushNamed(ChatScreen.routeName);
      },
      child: FutureBuilder<DataState<Object?>>(
        future: otherId.startsWith('BU')
            ? getBusinessByIdUsecase.call(otherId)
            : getUserByUidUsecase.call(otherId),
        builder:
            (BuildContext context, AsyncSnapshot<DataState<Object?>> snapshot) {
          String displayName = 'na';
          String imageUrl = '';
          String id = otherId;

          if (snapshot.data is DataState<BusinessEntity?>) {
            final BusinessEntity? business =
                (snapshot.data as DataState<BusinessEntity?>).entity;
            displayName = business?.displayName ?? displayName;
            imageUrl = business?.logo?.url ?? '';
            id = business?.businessID ?? otherId;
          } else if (snapshot.data is DataState<UserEntity?>) {
            final UserEntity? user =
                (snapshot.data as DataState<UserEntity?>).entity;
            displayName = user?.displayName ?? displayName;
            imageUrl = user?.profilePhotoURL ?? '';
            id = user?.uid ?? otherId;
          }

          return Row(
            children: <Widget>[
              ProfilePictureWithStatus(
                postImageUrl: 'a',
                isProduct: false,
                userImageUrl: imageUrl,
                userDisplayName: displayName,
                userId: id,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      displayName,
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
      ),
    );
  }
}
