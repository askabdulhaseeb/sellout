import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/profile_photo.dart';
import '../../../../../../services/get_it.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../../../chat_dashboard/domain/entities/chat/group/group_into_entity.dart';
import '../../../chat_dashboard/domain/entities/chat/participant/chat_participant_entity.dart';
import '../providers/chat_provider.dart';


class ParticipantTile extends StatelessWidget {

  const ParticipantTile({required this.participant, super.key, this.onRemove});
  final ChatParticipantEntity? participant;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {final ChatProvider pro = Provider.of(context,listen: false);
    return FutureBuilder<DataState<UserEntity?>>(
      future: GetUserByUidUsecase(locator()).call(participant?.uid ?? ''),
      builder: (BuildContext context, AsyncSnapshot<DataState<UserEntity?>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(title: Text('loading'.tr()));
        }

    final  UserEntity? user =snapshot.data?.entity ;

        if (user == null) {
          return ListTile(
            title: Text('error_loading_user'.tr(), style: Theme.of(context).textTheme.bodyMedium),
          );
        }
        return ListTile(
          leading: ProfilePhoto(url:user.profilePhotoURL,isCircle: true,placeholder:'na'.tr() ,size: 20,),
          title: Text(user.displayName, style: Theme.of(context).textTheme.titleMedium),
          subtitle: Text(participant?.role.json ?? '', style: Theme.of(context).textTheme.bodySmall),
          trailing: Column(
            children: <Widget>[
           if(user.uid == LocalAuth.uid)   SizedBox(width: 100,
                child: CustomElevatedButton(isLoading: false,bgColor: AppTheme.primaryColor.withValues(alpha: 0.3),
                textColor:  AppTheme.primaryColor,textStyle: TextTheme.of(context).bodySmall,
                 onTap: () {pro.leaveGroup();},
                 title: 'remove_person'.tr(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


class GroupDetailScreen extends StatelessWidget {
  const GroupDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatProvider pro = Provider.of<ChatProvider>(context, listen: false);
    final GroupInfoEntity? groupInfo = pro.chat?.groupInfo;

    return Scaffold(
      appBar: AppBar(title: Text('group_detail'.tr())),
      body: groupInfo == null
          ? Center(child: Text('error_loading_group'.tr()))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 24),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(groupInfo.groupThumbnailURL ?? ''),
                ),
                const SizedBox(height: 16),
                Text(
                  groupInfo.title ?? 'na'.tr(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    groupInfo.description ?? 'na'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'participants'.tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: groupInfo.participants.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ParticipantTile(
                        participant: groupInfo.participants[index],
                        onRemove: () {
                          // Optional: add remove logic here
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
