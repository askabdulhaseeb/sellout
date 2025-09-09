import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../services/get_it.dart';
import '../../../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../../../business/core/domain/usecase/get_business_by_id_usecase.dart';
import '../../../../../../post/data/sources/local/local_post.dart';
import '../../../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../../post/domain/usecase/get_specific_post_usecase.dart';
import '../../../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../../../../../chat/views/providers/chat_provider.dart';
import '../../../../../chat/views/screens/chat_screen.dart';
import '../../../../data/sources/local/local_unseen_messages.dart';
import '../../../../domain/entities/chat/chat_entity.dart';
import '../../chat_profile_with_status.dart';
import '../../unseen_message_badge.dart';

class ProductChatDashboardTile extends HookWidget {
  const ProductChatDashboardTile({required this.chat, super.key});
  final ChatEntity chat;

  @override
  Widget build(BuildContext context) {
    final ChatProvider pro = Provider.of<ChatProvider>(context, listen: false);
    final GetSpecificPostUsecase postUsecase =
        GetSpecificPostUsecase(locator());
    final GetUserByUidUsecase getUserByUidUsecase =
        GetUserByUidUsecase(locator());
    final GetBusinessByIdUsecase getBusinessByIdUsecase =
        GetBusinessByIdUsecase(locator());
    final String otherId = chat.otherPerson();

    return GestureDetector(
      onTap: () async {
        pro.setChat(context, chat);
        await LocalUnreadMessagesService().clearCount(chat.chatId);
        Navigator.of(context).pushNamed(ChatScreen.routeName);
      },
      child: Column(
        children: <Widget>[
          FutureBuilder<DataState<PostEntity>>(
            future: postUsecase(
                GetSpecificPostParam(postId: chat.productInfo?.id ?? '')),
            initialData: LocalPost().dataState(chat.productInfo?.id ?? ''),
            builder: (BuildContext context,
                AsyncSnapshot<DataState<PostEntity>> postSnapshot) {
              final PostEntity? post = postSnapshot.data?.entity;
              // --- Decide which future to call based on ID prefix ---
              final bool isBusiness = otherId.startsWith('BU');
              final Future<DataState<Object?>> future = isBusiness
                  ? getBusinessByIdUsecase.call(otherId)
                  : getUserByUidUsecase.call(otherId);
              return FutureBuilder(
                future: future,
                initialData: isBusiness ? null : LocalUser().userState(otherId),
                builder: (BuildContext context,
                    AsyncSnapshot<DataState<Object?>> snapshot) {
                  // Handle both entity types
                  String displayName = post?.title ?? '';
                  String imageUrl = post?.imageURL ?? '';
                  String id = otherId;
                  if (isBusiness &&
                      snapshot.data is DataState<BusinessEntity?>) {
                    final BusinessEntity? business =
                        (snapshot.data as DataState<BusinessEntity?>).entity;
                    displayName = displayName;
                    imageUrl = business?.logo?.url ?? imageUrl;
                    id = business?.businessID ?? id;
                  } else if (!isBusiness &&
                      snapshot.data is DataState<UserEntity?>) {
                    final UserEntity? user =
                        (snapshot.data as DataState<UserEntity?>).entity;
                    displayName = user?.displayName ?? displayName;
                    imageUrl = user?.profilePhotoURL ?? displayName;
                    id = user?.uid ?? id;
                  }
                  return Row(
                    children: <Widget>[
                      ProfilePictureWithStatus(
                        isProduct: true,
                        postImageUrl: post?.imageURL ?? '',
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
            },
          ),
        ],
      ),
    );
  }
}
