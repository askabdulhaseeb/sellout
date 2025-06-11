import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../chat_dashboard/domain/entities/chat/participant/invitation_entity.dart';
import '../providers/chat_provider.dart';
import '../widgets/app_bar/chat_app_bar.dart';
import '../widgets/input_field/chat_input_field.dart';
import '../widgets/message/messages_list.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const String routeName = '/chat';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    Provider.of<ChatProvider>(context, listen: false).getMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(  Provider.of<ChatProvider>(context, listen: false).chat?.persons.toString());
    return Scaffold( 
      resizeToAvoidBottomInset: true,
      appBar: chatAppBar(context),
      body: const SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(child: MessagesList()),
            SendMessageWidget()
          ],
        ),
      ),
    );
  }
}
class SendMessageWidget extends StatelessWidget {
  const SendMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {

       return Consumer<ChatProvider>(builder: (BuildContext context, ChatProvider pro, Widget? child) {
            final bool isInivitations = pro.chat
            ?.groupInfo
            ?.invitations
            .any(( InvitationEntity inivitations) => inivitations.uid == LocalAuth.uid) ==
        true;
        return     Column(
      children: <Widget>[
        if (!isInivitations) const ChatInputField(),
 if (isInivitations) const GroupInviteActionWidget()
      ],
    );});
  }
}
class GroupInviteActionWidget extends StatelessWidget {
  const GroupInviteActionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatProvider pro = Provider.of<ChatProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: ColorScheme.of(context).surfaceContainer,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
           'You_have_been_added_group'.tr()
,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CustomElevatedButton(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                isLoading: false,
                borderRadius: BorderRadius.circular(30),
                textStyle: TextTheme.of(context)
                    .bodySmall
                    ?.copyWith(color: ColorScheme.of(context).onPrimary),
                bgColor: AppTheme.primaryColor,
                title: 'accept'.tr(),
                onTap: () {
              pro.acceptGroupInvite(context);
                },
              ),
              CustomElevatedButton(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                isLoading: false,
                borderRadius: BorderRadius.circular(30),
                textStyle: TextTheme.of(context)
                    .bodySmall
                    ?.copyWith(color: AppTheme.secondaryColor),
                bgColor: Colors.transparent,
                border: Border.all(color: AppTheme.secondaryColor),
                title: 'decline'.tr(),
                onTap: () {

                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
