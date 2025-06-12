import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../../services/get_it.dart';
import '../../../../../user/profiles/domain/entities/user_entity.dart';
import '../../../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../../../../chat_dashboard/domain/entities/chat/participant/chat_participant_entity.dart';

class ParticipantTile extends StatelessWidget {
  const ParticipantTile({required this.participant, super.key});
  final ChatParticipantEntity? participant;

  @override
  Widget build(BuildContext context) {
    // final ChatProvider pro = Provider.of<ChatProvider>(context, listen: false);
    return FutureBuilder<DataState<UserEntity?>>(
      future: GetUserByUidUsecase(locator()).call(participant?.uid ?? ''),
      builder: (BuildContext context, AsyncSnapshot<DataState<UserEntity?>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(title: Text('loading'.tr()));
        }
        final UserEntity? user = snapshot.data?.entity;
        if (user == null) {
          return ListTile(
            title: Text('error_loading_user'.tr(), style: Theme.of(context).textTheme.bodyMedium),
          );
        }

        return ListTile(
          leading: ProfilePhoto(
            url: user.profilePhotoURL,
            isCircle: true,
            placeholder: 'na'.tr(),
            size: 20,
          ),
          title: Text(user.displayName, style: Theme.of(context).textTheme.titleMedium),
          subtitle: Text(participant?.role.json ?? '', style: Theme.of(context).textTheme.bodySmall),
        );
      },
    );
  }
}

