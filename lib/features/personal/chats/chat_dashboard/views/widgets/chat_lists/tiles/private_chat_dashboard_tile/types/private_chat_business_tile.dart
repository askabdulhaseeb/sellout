import 'package:flutter/material.dart';
import '../../../../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../../../../core/sources/api_call.dart';
import '../../../../../../../../../../core/widgets/loaders/simple_tile_loader.dart';
import '../../../../../../../../../../services/get_it.dart';
import '../../../../../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../../../../../business/core/domain/usecase/get_business_by_id_usecase.dart';
import '../../../../../../data/models/chat/chat_model.dart';
import '../../../../chat_profile_with_status.dart';
import '../../../../unseen_message_badge.dart';

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
        final BusinessEntity? business = snapshot.data?.entity;
        if (business == null) {
          return const SimpleTileLoader();
        }
        return Row(
          children: <Widget>[
            ProfilePictureWithStatus(
              isProduct: false,
              postImageUrl: business.logo?.url ?? '',
              userImageUrl: '',
              userDisplayName: business.displayName ?? '',
              userId: business.businessID ?? '',
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    spacing: 2,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          business.displayName ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      CircleAvatar(
                        radius: 8,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          'B',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ],
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
