import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../../core/widgets/custom_svg_icon.dart';
import '../../../providers/send_message_provider.dart';

class SendMessageButton extends StatelessWidget {
  const SendMessageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SendMessageProvider>(
      builder: (_, SendMessageProvider msgPro, __) {
        return IconButton(
          icon: msgPro.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const CustomSvgIcon(assetPath: AppStrings.selloutChatSendIcon),
          onPressed: () async {
            if (!msgPro.isLoading) {
              await msgPro.sendMessage(context);
            }
          },
        );
      },
    );
  }
}
