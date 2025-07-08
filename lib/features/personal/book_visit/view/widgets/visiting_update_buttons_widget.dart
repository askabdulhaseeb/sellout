import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/enums/core/status_type.dart';
import '../../../../../routes/app_linking.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../chats/chat/domain/entities/getted_message_entity.dart';
import '../../../chats/chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../provider/booking_provider.dart';
import '../screens/booking_screen.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import 'cancel_visiting_dialog.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../../../core/utilities/app_string.dart';

class VisitingMessageTileUpdateButtonsWidget extends StatelessWidget {
  const VisitingMessageTileUpdateButtonsWidget({
    required this.message,
    this.post,
    super.key,
  });

  final MessageEntity message;
  final PostEntity? post;

  @override
  Widget build(BuildContext context) {
    final Box<GettedMessageEntity> box =
        Hive.box<GettedMessageEntity>(AppStrings.localChatMessagesBox);

    return ValueListenableBuilder<Box<GettedMessageEntity>>(
      valueListenable: box.listenable(),
      builder: (BuildContext context, Box<GettedMessageEntity> box, Widget? _) {
        final GettedMessageEntity? gettedEntity = box.get(message.chatId);
        final MessageEntity? freshMessage = gettedEntity?.messages.firstWhere(
          (MessageEntity m) => m.messageId == message.messageId,
        );

        if (freshMessage == null || freshMessage.visitingDetail == null) {
          return const SizedBox();
        }

        final bool isHost = freshMessage.visitingDetail!.hostID ==
            LocalAuth.currentUser?.userID;
        final StatusType status = freshMessage.visitingDetail!.status;

        return Column(
          children: <Widget>[
            if (!isHost && status == StatusType.pending)
              CancelAndChangeButtons(message: freshMessage, post: post),
            if (isHost && status == StatusType.pending)
              HostPendingButtons(message: freshMessage),
            if (isHost && status == StatusType.accepted)
              HostDoneButton(message: freshMessage),
          ],
        );
      },
    );
  }
}

class CancelAndChangeButtons extends StatelessWidget {
  const CancelAndChangeButtons({
    required this.message,
    this.post,
    super.key,
  });

  final MessageEntity message;
  final PostEntity? post;

  @override
  Widget build(BuildContext context) {
    final BookingProvider pro =
        Provider.of<BookingProvider>(context, listen: false);

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: CustomElevatedButton(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(4),
                bgColor: Colors.transparent,
                border: Border.all(color: Theme.of(context).primaryColor),
                textColor: Theme.of(context).primaryColor,
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) =>
                        CancelVisitingDialog(pro: pro, message: message),
                  );
                },
                isLoading: false,
                title: 'cancel_viewing'.tr(),
              ),
            ),
            Expanded(
              child: CustomElevatedButton(
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.all(4),
                title: 'change_date'.tr(),
                isLoading: false,
                textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).canvasColor),
                onTap: () {
                  pro.setMessageEntity(message);
                  AppNavigator.pushNamed(BookingScreen.routeName,
                      arguments: <String, dynamic>{
                        'post': post,
                        'visit': message.visitingDetail
                      });
                },
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}

class HostPendingButtons extends StatelessWidget {
  const HostPendingButtons({required this.message, super.key});

  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    final BookingProvider pro =
        Provider.of<BookingProvider>(context, listen: false);

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: CustomElevatedButton(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(4),
                bgColor: Colors.transparent,
                border: Border.all(color: Theme.of(context).primaryColor),
                textColor: Theme.of(context).primaryColor,
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
                onTap: () {
                  pro.updateVisit(
                    query: 'status',
                    status: 'reject',
                    chatID: message.chatId,
                    context: context,
                    visitingId: message.visitingDetail?.visitingID ?? '',
                    messageId: message.messageId,
                  );
                },
                isLoading: false,
                title: 'reject_viewing'.tr(),
              ),
            ),
            Expanded(
              child: CustomElevatedButton(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(4),
                bgColor: Colors.transparent,
                border: Border.all(color: Theme.of(context).primaryColor),
                textColor: Theme.of(context).primaryColor,
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
                onTap: () {
                  pro.updateVisit(
                    query: 'status',
                    status: 'accept',
                    chatID: message.chatId,
                    context: context,
                    visitingId: message.visitingDetail?.visitingID ?? '',
                    messageId: message.messageId,
                  );
                },
                isLoading: false,
                title: 'accept_viewing'.tr(),
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}

class HostDoneButton extends StatelessWidget {
  const HostDoneButton({required this.message, super.key});

  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    final BookingProvider pro =
        Provider.of<BookingProvider>(context, listen: false);

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: CustomElevatedButton(
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.all(4),
                title: 'visiting_done'.tr(),
                isLoading: false,
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).canvasColor,
                ),
                onTap: () {
                  pro.updateVisit(
                    query: 'status',
                    status: 'happened',
                    chatID: message.chatId,
                    context: context,
                    visitingId: message.visitingDetail?.visitingID ?? '',
                    messageId: message.messageId,
                  );
                },
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
