import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              : const Icon(Icons.send_outlined),
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
