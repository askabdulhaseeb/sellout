import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../chats/chat_dashboard/domain/entities/messages/message_entity.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Center(
        child: Text(
          'are_you_sure'.tr(),
          style: TextTheme.of(context).titleMedium,
        ),
      ),
      content: Text(
        textAlign: TextAlign.center,
        'cancel_viewing_description'.tr(),
        style: TextTheme.of(context).bodyMedium,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      actions: <Widget>[
        Row(
          spacing: 4,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: CustomElevatedButton(
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
                title: 'discard'.tr(),
              ),
            ),
            Expanded(
              child: CustomElevatedButton(
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).canvasColor,
                ),
                isLoading: false,
                onTap: () {
                  pro.updateVisit(
                    query: 'status',
                    status: 'cancel',
                    chatID: message.chatId,
                    context: context,
                    visitingId: message.visitingDetail?.visitingID ?? '',
                    messageId: message.messageId,
                  );
                  Navigator.pop(context);
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
