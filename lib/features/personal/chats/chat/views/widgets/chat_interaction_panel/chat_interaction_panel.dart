import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../chat_dashboard/data/models/chat/chat_model.dart';
import '../../../../chat_dashboard/domain/entities/chat/group/group_into_entity.dart';
import '../../../../chat_dashboard/domain/entities/chat/participant/chat_participant_entity.dart';
import '../../../../chat_dashboard/domain/entities/chat/participant/invitation_entity.dart';
import '../../providers/chat_provider.dart';
import 'group_invite_action_widget.dart/group_invite_action_widget.dart';
import 'send_message_panel/send_message_panel.dart';
import 'send_message_panel/widgets/send_message_attachment_bottomsheets/send_message_emogi_picker_bottomsheet.dart';

class ChatInteractionPanel extends StatelessWidget {
  const ChatInteractionPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (BuildContext context, ChatProvider pro, Widget? child) {
        final GroupInfoEntity? groupInfo = pro.chat?.groupInfo;
        final String? currentUid = LocalAuth.uid;

        final bool isInvited =
            groupInfo?.invitations.any(
              (InvitationEntity invitation) => invitation.uid == currentUid,
            ) ==
            true;

        final bool isParticipant =
            groupInfo?.participants.any(
              (ChatParticipantEntity participant) =>
                  participant.uid == currentUid,
            ) ==
            true;

        if (pro.chat?.type == ChatType.group) {
          if (isParticipant) {
            return const Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[SendMessagePanel(), InlineEmojiPicker()],
            );
          } else if (isInvited) {
            return const GroupInviteActionWidget();
          } else {
            return Text('you_are_not_participant_group'.tr());
          }
        }

        if (pro.chat?.type == ChatType.private ||
            pro.chat?.type == ChatType.product) {
          return const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[SendMessagePanel(), InlineEmojiPicker()],
          );
        }

        // Default fallback
        return const SizedBox();
      },
    );
  }
}
