import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../chats/chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../provider/view_booking_provider.dart';
import '../screens/view_booking_screen.dart';
import 'cancel_visiting_dialog.dart';

class VisitingUpdateButtonsWidget extends StatelessWidget {
  const VisitingUpdateButtonsWidget({
    required this.message,
    super.key,
    this.post,
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
                      builder: (BuildContext context) {
                        return CancelVisitingDialog(pro: pro, message: message);
                      },
                    );
                  },
                  isLoading: false,
                  title: 'cancel_viewing'.tr()),
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
                    final BookingProvider pro =
                        Provider.of<BookingProvider>(context, listen: false);
                    pro.setMessageEntity(message);
                    Navigator.pushNamed(context, BookingScreen.routeName,
                        arguments: <String, dynamic>{'post': post});
                  }),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
