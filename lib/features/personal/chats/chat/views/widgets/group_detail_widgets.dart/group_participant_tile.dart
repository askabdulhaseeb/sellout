import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/chat/chat_participant_role.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../../../../core/widgets/media/profile_photo.dart';
import '../../../../../../../services/get_it.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../user/profiles/domain/entities/user_entity.dart';
import '../../../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../../../../chat_dashboard/domain/entities/chat/participant/chat_participant_entity.dart';
import '../../providers/chat_provider.dart';

class ParticipantTile extends StatelessWidget {
  const ParticipantTile({required this.participant, super.key});

  final ChatParticipantEntity? participant;

  @override
  Widget build(BuildContext context) {
    final ChatProvider pro = Provider.of<ChatProvider>(context, listen: false);
    final bool isCurrentUserAdmin = _isCurrentUserAdmin(pro);
    final bool isParticipantAdmin =
        participant?.role == ChatParticipantRoleType.admin;

    return FutureBuilder<DataState<UserEntity?>>(
      future: GetUserByUidUsecase(locator()).call(participant?.uid ?? ''),
      builder:
          (
            BuildContext context,
            AsyncSnapshot<DataState<UserEntity?>> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListTile(title: Text('loading'.tr()));
            }

            final UserEntity? user = snapshot.data?.entity;

            if (user == null) {
              return ListTile(
                title: Text(
                  'error_loading_user'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }

            return ListTile(
              leading: ProfilePhoto(
                url: user.profilePhotoURL,
                placeholder: user.displayName,
                size: 25,
              ),
              title: Text(
                user.displayName,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                participant?.role.json ?? '',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: (!isParticipantAdmin && isCurrentUserAdmin)
                  ? SizedBox(
                      width: 70,
                      child: CustomElevatedButton(
                        bgColor: Colors.transparent,
                        padding: const EdgeInsets.all(0),
                        title: 'remove'.tr(),
                        textStyle: Theme.of(context).textTheme.labelSmall
                            ?.copyWith(color: Theme.of(context).primaryColor),
                        isLoading: false,
                        onTap: () {
                          pro.removeFromGroup(context, participant?.uid ?? '');
                        },
                      ),
                    )
                  : null,
            );
          },
    );
  }

  bool _isCurrentUserAdmin(ChatProvider pro) {
    final String? currentUserId = LocalAuth.uid;
    return pro.chat?.groupInfo?.participants.any(
          (ChatParticipantEntity e) =>
              e.role == ChatParticipantRoleType.admin && e.uid == currentUserId,
        ) ==
        true;
  }
}
