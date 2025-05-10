import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../services/get_it.dart';
import '../../../../../../post/data/sources/local/local_post.dart';
import '../../../../../../post/domain/entities/post_entity.dart';
import '../../../../../../post/domain/usecase/get_specific_post_usecase.dart';
import '../../../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../../../../../chat/views/providers/chat_provider.dart';
import '../../../../../chat/views/screens/chat_screen.dart';
import '../../../../domain/entities/chat/chat_entity.dart';
import '../../chat_profile_with_status.dart';
import '../../unseen_message_badge.dart';

class ProductChatDashboardTile extends HookWidget {
  const ProductChatDashboardTile({required this.chat, super.key});
  final ChatEntity chat;

  @override
  Widget build(BuildContext context) {
    final GetSpecificPostUsecase postUsecase =
        GetSpecificPostUsecase(locator());
    final GetUserByUidUsecase getUserByUidUsecase =
        GetUserByUidUsecase(locator());
    return GestureDetector(
      onTap: () {
        Provider.of<ChatProvider>(context, listen: false).chat = chat;
        SeenMessageCounter.reset(chat.chatId);
        Navigator.of(context).pushNamed(ChatScreen.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          children: <Widget>[
            FutureBuilder<DataState<PostEntity>>(
              future: postUsecase(
                GetSpecificPostParam(postId: chat.productInfo?.id ?? ''),
              ),
              initialData: LocalPost().dataState(chat.productInfo?.id ?? ''),
              builder: (BuildContext context,
                  AsyncSnapshot<DataState<PostEntity>> postSnapshot) {
                final PostEntity? post = postSnapshot.data?.entity;

                return FutureBuilder<DataState<UserEntity?>>(
                  future: getUserByUidUsecase.call(chat.otherPerson()),
                  initialData: LocalUser().userState(chat.otherPerson()),
                  builder: (BuildContext context,
                      AsyncSnapshot<DataState<UserEntity?>> userSnapshot) {
                    final UserEntity? user = userSnapshot.data?.entity;
                    return Row(
                      children: <Widget>[
                        ProfilePictureWithStatus(
                          isProduct: true,
                          postImageUrl: post?.imageURL ?? '',
                          userImageUrl:
                              user?.profilePhotoURL ?? user?.displayName ?? '',
                          userDisplayName:
                              user?.displayName ?? post?.title ?? '',
                          userId: user?.uid ?? '',
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                post?.title ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
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
                            UnseenMessageBadge(
                              chat: chat,
                            )
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
