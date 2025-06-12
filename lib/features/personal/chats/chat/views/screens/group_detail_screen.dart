import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/profile_photo.dart';
import '../../../chat_dashboard/domain/entities/chat/group/group_into_entity.dart';
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
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 24),
                 Hero(tag: 'group_profile',
                child: ProfilePhoto(size: 70,isCircle: true,
                  url: groupInfo.groupThumbnailURL,
                  placeholder: groupInfo.title,
                ),
              ),
                const SizedBox(height: 16),
                Text(
                  groupInfo.title ,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(overflow: TextOverflow.ellipsis,maxLines: 7,
                    groupInfo.description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ),
                GroupDetailParticipantsWidget(groupInfo: groupInfo),
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: AppTheme.primaryColor),
                  title: Text('leave_group'.tr(), style: Theme.of(context).textTheme.titleMedium),
                  onTap: () => pro.leaveGroup(),
                ),
                ListTile(
                  leading: const Icon(Icons.group_add, color: AppTheme.primaryColor),
                  title: Text('invite_to_group'.tr(), style: Theme.of(context).textTheme.titleMedium),
                  onTap: () => showInviteBottomSheet(context, pro),
                ),
                const Divider(),
              ],
            ),
    );
  }}
