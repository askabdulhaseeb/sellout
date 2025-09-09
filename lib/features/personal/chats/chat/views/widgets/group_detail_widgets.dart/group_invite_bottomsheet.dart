import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../../services/get_it.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../user/profiles/domain/entities/supporter_detail_entity.dart';
import '../../../../../user/profiles/domain/entities/user_entity.dart';
import '../../../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../../../../chat_dashboard/domain/entities/chat/group/group_into_entity.dart';
import '../../../../chat_dashboard/domain/entities/chat/participant/chat_participant_entity.dart';
import '../../../../chat_dashboard/domain/entities/chat/participant/invitation_entity.dart';
import '../../providers/chat_provider.dart';

void showInviteBottomSheet(BuildContext context, ChatProvider pro) {
  Future<List<UserEntity>> getSupporterUsers(
      List<SupporterDetailEntity> supporters) async {
    final GetUserByUidUsecase getUser = GetUserByUidUsecase(locator());
    final List<UserEntity> users = <UserEntity>[];

    for (final SupporterDetailEntity supporter in supporters) {
      final DataState<UserEntity?> result =
          await getUser.call(supporter.userID);
      final UserEntity? user = result.entity;
      if (user != null) users.add(user);
    }
    return users;
  }

  final GroupInfoEntity? groupInfo = pro.chat?.groupInfo;
  final List<String> participantUids = groupInfo?.participants
          .map((ChatParticipantEntity e) => e.uid)
          .toList() ??
      <String>[];
  final List<SupporterDetailEntity> supporters =
      LocalAuth.currentUser?.supporters ?? <SupporterDetailEntity>[];

  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      if (supporters.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              'no_supporters'.tr(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        );
      }

      return FutureBuilder<List<UserEntity>>(
        future: getSupporterUsers(supporters),
        builder:
            (BuildContext context, AsyncSnapshot<List<UserEntity>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final List<UserEntity> users = snapshot.data ?? <UserEntity>[];
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (BuildContext context, int index) {
              final UserEntity user = users[index];
              final List<String> invitedUids = groupInfo?.invitations
                      .map((InvitationEntity e) => e.uid)
                      .toList() ??
                  <String>[];
              final bool isAlreadyParticipant =
                  participantUids.contains(user.uid);
              final bool isAlreadyInvited = invitedUids.contains(user.uid);
              return ListTile(
                leading: ProfilePhoto(
                  url: user.profilePhotoURL,
                  isCircle: true,
                  placeholder: user.displayName,
                  size: 20,
                ),
                title: Text(
                  user.displayName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: SizedBox(
                  width: 100,
                  child: isAlreadyParticipant
                      ? CustomElevatedButton(
                          isLoading: false,
                          bgColor: AppTheme.secondaryColor.withAlpha(30),
                          textColor: AppTheme.secondaryColor,
                          textStyle: Theme.of(context).textTheme.bodySmall,
                          title: 'participant'.tr(),
                          onTap: () {},
                        )
                      : isAlreadyInvited
                          ? CustomElevatedButton(
                              isLoading: false,
                              bgColor: Colors.grey.withAlpha(30),
                              textColor: Colors.grey,
                              textStyle: Theme.of(context).textTheme.bodySmall,
                              title: 'invited'.tr(),
                              onTap: () {},
                            )
                          : CustomElevatedButton(
                              isLoading: false,
                              bgColor: AppTheme.primaryColor.withAlpha(30),
                              textColor: AppTheme.primaryColor,
                              textStyle: Theme.of(context).textTheme.bodySmall,
                              title: 'invite'.tr(),
                              onTap: () {
                                pro.sendGroupInvite(<String>[user.uid]);
                                Navigator.pop(context);
                              },
                            ),
                ),
              );
            },
          );
        },
      );
    },
  );
}
