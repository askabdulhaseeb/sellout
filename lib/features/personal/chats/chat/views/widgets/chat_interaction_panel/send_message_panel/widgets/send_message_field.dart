import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../providers/send_message_provider.dart';

class SendMessageFIeld extends StatelessWidget {
  const SendMessageFIeld({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SendMessageProvider>(
      builder: (_, SendMessageProvider msgPro, __) {
        return CustomTextFormField(
          controller: msgPro.message,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
          minLines: 1,
          maxLines: 5,
          hint: 'your_message_here'.tr(),
        );
      },
    );
  }
}
