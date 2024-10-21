import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../../../../services/get_it.dart';
import '../../../../../../post/data/sources/local/local_post.dart';
import '../../../../../../post/domain/entities/post_entity.dart';
import '../../../../../../post/domain/usecase/get_specific_post_usecase.dart';
import '../../../../../chat/views/providers/chat_provider.dart';
import '../../../../../chat/views/screens/chat_screen.dart';
import '../../../../domain/entities/chat/chat_entity.dart';

class ProductChatDashboardTile extends StatelessWidget {
  const ProductChatDashboardTile({required this.chat, super.key});
  final ChatEntity chat;

  @override
  Widget build(BuildContext context) {
    final GetSpecificPostUsecase postUsecase =
        GetSpecificPostUsecase(locator());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ShadowContainer(
        onTap: () {
          Provider.of<ChatProvider>(context, listen: false).chat = chat;
          Navigator.of(context).pushNamed(ChatScreen.routeName);
        },
        child: FutureBuilder<DataState<PostEntity>>(
            future: postUsecase(
              GetSpecificPostParam(postId: chat.productInfo?.id ?? ''),
            ),
            initialData: LocalPost().dataState(chat.productInfo?.id ?? ''),
            builder: (
              BuildContext context,
              AsyncSnapshot<DataState<PostEntity>> snapshot,
            ) {
              final PostEntity? post = snapshot.data?.entity;
              return Row(
                children: <Widget>[
                  ProfilePhoto(
                    url: post?.imageURL,
                    placeholder: post?.title ?? '',
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
                  Text(
                    chat.lastMessage?.createdAt.timeAgo ?? '',
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
