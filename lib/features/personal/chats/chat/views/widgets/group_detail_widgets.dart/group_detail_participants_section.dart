
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../chat_dashboard/domain/entities/chat/group/group_into_entity.dart';
import 'group_participant_tile.dart';

class GroupDetailParticipantsWidget extends StatelessWidget {
  const GroupDetailParticipantsWidget({
    super.key,
    required this.groupInfo,
  });

  final GroupInfoEntity? groupInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        SizedBox(
          child: ListView.builder(shrinkWrap: true,
            itemCount: groupInfo?.participants.length,
            itemBuilder: (BuildContext context, int index) {
              return ParticipantTile(participant: groupInfo?.participants[index]);
            },
          ),
        ), 
        const Divider(),
      ],
    );
  }
}