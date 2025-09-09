import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../../core/widgets/empty_page_widget.dart';

class ServicesChatListWidget extends StatelessWidget {
  const ServicesChatListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: EmptyPageWidget(
          icon: CupertinoIcons.chat_bubble_2,
          childBelow: Text('no_chats_found'.tr()),
        ),
      ),
    );
  }
}
