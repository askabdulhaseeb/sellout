import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../../../core/widgets/loader.dart';
import '../../../../../../../../services/get_it.dart';
import '../../../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../../../../domain/entities/chat/chat_entity.dart';
import '../../chat_profile_with_status.dart';

class PrivateChatDashboardTile extends StatelessWidget {
  const PrivateChatDashboardTile({required this.chat, super.key});
  final ChatEntity chat;

  @override
  Widget build(BuildContext context) {
    final GetUserByUidUsecase getUserByUidUsecase =
        GetUserByUidUsecase(locator());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          FutureBuilder<DataState<UserEntity?>>(
            future: getUserByUidUsecase.call(chat.otherPerson()),
            initialData: LocalUser().userState(chat.otherPerson()),
            builder: (BuildContext context,
                AsyncSnapshot<DataState<UserEntity?>> snapshot) {
              final UserEntity? user = snapshot.data?.entity;
              return user == null
                  ? snapshot.connectionState == ConnectionState.waiting
                      ? const Loader()
                      : Text(snapshot.data?.exception?.message ??
                          'user_not_found'.tr())
                  : Row(
                      children: <Widget>[
                        ProfilePictureWithStatus(
                          isProduct: false,
                          postImageUrl:
                              user.profilePhotoURL ?? user.displayName,
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
                        Text(
                          chat.lastMessage?.createdAt.timeAgo ?? '',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    );
            },
          ),
          const Divider()
        ],
      ),
    );
  }
}
