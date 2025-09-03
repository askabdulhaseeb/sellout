import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/enums/core/status_type.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../chats/chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../provider/booking_provider.dart';
import '../screens/booking_screen.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import 'cancel_visiting_dialog.dart';

class VisitingMessageTileUpdateButtonsWidget extends StatefulWidget {
  const VisitingMessageTileUpdateButtonsWidget({
    required this.message,
    this.post,
    super.key,
  });

  final MessageEntity message;
  final PostEntity? post;

  @override
  State<VisitingMessageTileUpdateButtonsWidget> createState() =>
      _VisitingMessageTileUpdateButtonsWidgetState();
}

class _VisitingMessageTileUpdateButtonsWidgetState
    extends State<VisitingMessageTileUpdateButtonsWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final StatusType status = widget.message.visitingDetail!.status;
      if (status == StatusType.accepted) {
        _checkAndUpdateVisit();
      }
    });
  }

  void _checkAndUpdateVisit() {
    final BookingProvider pro =
        Provider.of<BookingProvider>(context, listen: false);
    final DateTime? visitTime = widget.message.visitingDetail?.dateTime;
    if (visitTime == null) return;
    final DateTime now = DateTime.now();
    if (now.isAfter(visitTime)) {
      _updateVisit(pro);
    } else {
      final Duration delay = visitTime.difference(now);
      Future<void>.delayed(delay, () => _updateVisit(pro));
    }
  }

  void _updateVisit(BookingProvider pro) {
    pro.updateVisit(
      query: 'status',
      status: 'happened',
      chatID: widget.message.chatId,
      context: context,
      visitingId: widget.message.visitingDetail?.visitingID ?? '',
      messageId: widget.message.messageId,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.message.visitingDetail == null) {
      return const SizedBox();
    }

    final bool isHost =
        widget.message.visitingDetail!.hostID == LocalAuth.currentUser?.userID;
    final StatusType status = widget.message.visitingDetail!.status;

    return Column(
      children: <Widget>[
        if (!isHost && status == StatusType.pending)
          CancelAndChangeButtons(message: widget.message, post: widget.post),
        if (isHost && status == StatusType.pending)
          HostPendingButtons(message: widget.message),
        // HostDoneButton(message: widget.message),
      ],
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
    final DateTime? createdAt = message.visitingDetail!.createdAt;
    final bool cancellationTimeOver =
        createdAt != null && DateTime.now().difference(createdAt).inHours >= 24;

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            if (!cancellationTimeOver)
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
