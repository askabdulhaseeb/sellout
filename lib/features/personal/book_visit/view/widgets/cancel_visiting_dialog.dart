import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../chats/chat_dashboard/domain/entities/messages/message_entity.dart';
import '../provider/booking_provider.dart';

class CancelVisitingDialog extends StatelessWidget {
  const CancelVisitingDialog({
    required this.pro,
    required this.message,
    super.key,
  });

  final BookingProvider pro;
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('are_you_sure'.tr())),
      content:
          Text(textAlign: TextAlign.center, 'cancel_viewing_description'.tr()),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: CustomElevatedButton(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.all(6),
                  bgColor: Colors.transparent,
                  border: Border.all(color: Theme.of(context).primaryColor),
                  textColor: Theme.of(context).primaryColor,
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                  isLoading: false,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  title: 'discard'.tr()),
            ),
            Expanded(
              child: CustomElevatedButton(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(6),
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).canvasColor,
                ),
                isLoading: false,
                onTap: () {
                  pro.updateVisitStatus(
                      status: 'cancel',
                      chatID: message.chatId,
                      context: context,
                      visitingId: message.visitingDetail?.visitingID ?? '',
                      messageId: message.messageId);
                },
                title: 'confirm'.tr(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
