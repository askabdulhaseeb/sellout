import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../providers/chat_provider.dart';
import 'widgets/chat_input_recording_widget.dart';
import 'widgets/input_field_pop_menu/chat_input_pop_menu.dart';
import 'widgets/input_field_pop_menu/subwidgets/chat_input_attachment_slider.dart';
import 'widgets/field_input_bottomsheets/chat_input_emogi_picker_bottomsheet.dart';
class ChatInputField extends StatelessWidget {
  const ChatInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
          ),
          child: Consumer<ChatProvider>(
            builder: (BuildContext context, ChatProvider chatPro, _) {
              // ⏺️ Show Audio Recorder if active
              if (chatPro.isRecordingAudio) {
                return ChatInputRecordingWidget(
                  onSend: (File audioFile) {
                    final PickedAttachment attachment = PickedAttachment(file: audioFile, type: AttachmentType.audio);
                    chatPro.addAttachment(attachment);
                  },
                  onCancel: () {
                    // Optional additional cancel logic here
                  },
                );
              }

              // 💬 Normal Chat UI
              return Column(
                children: <Widget>[
                  if (chatPro.attachments.isNotEmpty)
                    ChatAttachmentsListView(attachments: chatPro.attachments),
           ValueListenableBuilder<TextEditingValue>(
  valueListenable: chatPro.message,
  builder: (BuildContext context, TextEditingValue value, Widget? child) {
    final bool isEmpty = value.text.isEmpty;
    return Row(
      children: <Widget>[
        if (isEmpty) const AttachmentMenuButton(),

        IconButton(
          icon: const Icon(Icons.emoji_emotions_outlined),
          onPressed: () => showEmojiPickerBottomSheet(context),
        ),

        Expanded(
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
        ),

        if (isEmpty)
          IconButton(
            icon: const Icon(Icons.mic_none_outlined),
            onPressed: chatPro.startRecording,
          ),

        if (!isEmpty)
          IconButton(
            icon: const Icon(Icons.send_outlined),
            onPressed: () async {
              await chatPro.sendMessage(context);
            },
          ),
      ],
    );
  },
),
     ],
              );
            },
          ),
        ),
      ],
    );
  }
}
