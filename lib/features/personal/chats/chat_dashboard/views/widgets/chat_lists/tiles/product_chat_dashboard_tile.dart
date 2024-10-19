import 'package:flutter/material.dart';

import '../../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../../../core/widgets/shadow_container.dart';
import '../../../../domain/entities/chat/chat_entity.dart';

class ProductChatDashboardTile extends StatelessWidget {
  const ProductChatDashboardTile({required this.chat, super.key});
  final ChatEntity chat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ShadowContainer(
        child: Row(
          children: <Widget>[
            ProfilePhoto(
              url: null,
              isCircle: true,
              placeholder: chat.productInfo?.id ?? '',
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    chat.productInfo?.id ?? '',
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
        ),
      ),
    );
  }
}
