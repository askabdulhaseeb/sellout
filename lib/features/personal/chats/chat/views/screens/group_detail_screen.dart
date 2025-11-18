import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/enums/chat/chat_participant_role.dart';
import '../../../../../../core/widgets/profile_photo.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../chat_dashboard/domain/entities/chat/group/group_into_entity.dart';
import '../../../chat_dashboard/domain/entities/chat/participant/chat_participant_entity.dart';
import '../providers/chat_provider.dart';
import '../widgets/group_detail_widgets.dart/group_detail_participants_section.dart';
import '../widgets/group_detail_widgets.dart/group_invite_bottomsheet.dart';

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
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 24),
                  Hero(
                    tag: 'group_profile',
                    child: ProfilePhoto(
                      size: 60,
                      url: groupInfo.groupThumbnailURL,
                      placeholder: groupInfo.title,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    groupInfo.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 7,
                      groupInfo.description,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey),
                    ),
                  ),
                  const GroupDetailParticipantsWidget(),
                  if (!_isAdmin(pro))
                    ListTile(
                      leading: Icon(Icons.exit_to_app,
                          color: Theme.of(context).primaryColor),
                      title: Text('leave_group'.tr(),
                          style: Theme.of(context).textTheme.titleMedium),
                      onTap: () => pro.leaveGroup(context),
                    ),
                  if (_isAdmin(pro))
                    ListTile(
                      leading: Icon(Icons.group_add,
                          color: Theme.of(context).primaryColor),
                      title: Text('invite_to_group'.tr(),
                          style: Theme.of(context).textTheme.titleMedium),
                      onTap: () => showInviteBottomSheet(context, pro),
                    ),
                  const Divider(),
                ],
              ),
            ),
    );
  }

  bool _isAdmin(ChatProvider pro) {
    final String? currentUserId = LocalAuth.uid;
    return pro.chat?.groupInfo?.participants.any(
          (ChatParticipantEntity e) =>
              e.role == ChatParticipantRoleType.admin && e.uid == currentUserId,
        ) ==
        true;
  }
}
