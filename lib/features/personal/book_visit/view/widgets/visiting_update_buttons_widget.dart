import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../chats/chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../../data/source/book_visit_api.dart';
import '../provider/view_booking_provider.dart';
import '../screens/view_booking_screen.dart';

class VisitingUpdateButtonsWidget extends StatelessWidget {
  const VisitingUpdateButtonsWidget({
    super.key,
    required this.message,
    this.post,
  });
  final MessageEntity message;
  final PostEntity? post;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: CustomElevatedButton(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
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
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Center(child: Text('are_you_sure'.tr())),
                      content: Text(
                          textAlign: TextAlign.center,
                          'cancel_viewing_description'.tr()),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: CustomElevatedButton(
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.all(6),
                                  bgColor: Colors.transparent,
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor),
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
                                  Provider.of<BookingProvider>(context,
                                          listen: false)
                                      .cancelVisit(
                                          context: context,
                                          visitingId: message
                                                  .visitingDetail?.visitingID ??
                                              '',
                                          messageId: message.messageId);
                                },
                                title: 'confirm'.tr(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              isLoading: false,
              title: 'cancel_viewing'.tr()),
        ),
        Expanded(
          child: CustomElevatedButton(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              title: 'change_date'.tr(),
              isLoading: false,
              textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).canvasColor),
              onTap: () {
                final BookingProvider pro =
                    Provider.of<BookingProvider>(context, listen: false);
                pro.setMessageEntity(message);
                Navigator.pushNamed(context, BookingScreen.routeName,
                    arguments: <String, dynamic>{'post': post});
              }),
        ),
      ],
    );
  }
}
