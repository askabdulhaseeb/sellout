import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import 'group_participant_tile.dart';

class GroupDetailParticipantsWidget extends StatelessWidget {
  const GroupDetailParticipantsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (BuildContext context, ChatProvider pro, Widget? child) =>
          Column(
        children: <Widget>[
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
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: pro.chat?.groupInfo?.participants.length,
              itemBuilder: (BuildContext context, int index) {
                return ParticipantTile(
                  participant: pro.chat?.groupInfo?.participants[index],
                );
              },
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
