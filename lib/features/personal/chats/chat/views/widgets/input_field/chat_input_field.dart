import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/chat_provider.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Consumer<ChatProvider>(
          builder: (BuildContext context, ChatProvider chatPro, _) {
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: () {},
            ),
            Expanded(
              child: TextFormField(
                minLines: 1,
                maxLines: 5,
                controller: chatPro.message,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.unspecified,
                onChanged: (String value) => chatPro.onTextChange(value),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 8,
                  ),
                  suffixIcon: chatPro.message.text.isEmpty
                      ? IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.mic),
                        )
                      : IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () async =>
                              await chatPro.sendMessage(context),
                        ),
                  hoverColor: Theme.of(context).scaffoldBackgroundColor,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  focusColor: Theme.of(context).scaffoldBackgroundColor,
                  hintText: 'your_message_here'.tr(),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
