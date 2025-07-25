import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../providers/chat_provider.dart';
import 'widgets/send_message_panel_bottomsheets/send_message_emogi_picker_bottomsheet.dart';
import 'widgets/send_message_panel_pop_menu/send_message_pop_menu.dart';

class SendMessagePanel extends StatelessWidget {
  const SendMessagePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor,
      ),
      child: Consumer<ChatProvider>(
        builder: (BuildContext context, ChatProvider chatPro, _) {
          final bool hasText = chatPro.message.text.trim().isNotEmpty;
          final bool hasAttachments = chatPro.attachments.isNotEmpty;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              if (!hasText) const AttachmentMenuButton(),
              const EmojiPickerIconButton(),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ChatInputField(),
                ),
              ),
              if (!hasText && !hasAttachments) const RecordVoiceNoteWidget(),
              if (hasText || hasAttachments) const SendMessageButton(),
            ],
          );
        },
      ),
    );
  }
}

class SendMessageButton extends StatelessWidget {
  const SendMessageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (_, ChatProvider chatPro, __) {
        return IconButton(
          icon: chatPro.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.send_outlined),
          onPressed: () async {
            if (!chatPro.isLoading) {
              await chatPro.sendMessage(context);
            }
          },
        );
      },
    );
  }
}

class RecordVoiceNoteWidget extends StatelessWidget {
  const RecordVoiceNoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (_, ChatProvider chatPro, __) {
        return IconButton(
          icon: const Icon(Icons.mic_none_outlined),
          onPressed: chatPro.startRecording,
        );
      },
    );
  }
}

class ChatInputField extends StatelessWidget {
  const ChatInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (_, ChatProvider chatPro, __) {
        return Expanded(
          child: CustomTextFormField(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none,
            ),
            color: Theme.of(context).scaffoldBackgroundColor,
            controller: chatPro.message,
            minLines: 1,
            maxLines: 5,
            hint: 'your_message_here'.tr(),
          ),
        );
      },
    );
  }
}
