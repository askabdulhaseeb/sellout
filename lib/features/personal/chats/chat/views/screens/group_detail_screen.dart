import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../chat_dashboard/domain/entities/chat/group/group_into_entity.dart';
import '../../../chat_dashboard/domain/entities/chat/participant/chat_participant_entity.dart';
import '../providers/chat_provider.dart';

class GroupDetailScreen extends StatelessWidget {
  const GroupDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {final ChatProvider pro =Provider.of<ChatProvider>(context,listen: false);
  final GroupInfoEntity? groupInfo =pro.chat?.groupInfo;
    return Scaffold(
      appBar: AppBar(title: const Text('Group Details')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 24),
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(groupInfo?.groupThumbnailURL ?? ''),
          ),
          const SizedBox(height: 16),
          Text(
            groupInfo?.title ?? 'na'.tr(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              groupInfo?.description ?? 'na'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Participants',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: groupInfo?.participants.length,

              itemBuilder: (BuildContext context, int index) {              final ChatParticipantEntity? users = groupInfo?.participants[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(users?.uid ?? 'na'.tr())),
                  title: Text(users?.uid ?? 'na'.tr()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
