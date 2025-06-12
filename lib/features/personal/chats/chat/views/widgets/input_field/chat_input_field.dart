import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
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
              if (chatPro.isRecordingAudio) {
                return const SwipeToRecordWidget(
                );
              }
              return Column(
                children: <Widget>[
                  if (chatPro.attachments.isNotEmpty && !chatPro.isLoading)
                    ChatAttachmentsListView(attachments: chatPro.attachments),
           ValueListenableBuilder<TextEditingValue>(
  valueListenable: chatPro.message,
  builder: (BuildContext context, TextEditingValue value, Widget? child) {
    final bool isEmpty = value.text.isEmpty;
    return Row(
      children: <Widget>[
        if (isEmpty) const AttachmentMenuButton(),
                InkWell(
       child:  const Padding(padding: EdgeInsets.all(6),child: Icon(Icons.emoji_emotions_outlined)),
        onTap: () => showEmojiPickerBottomSheet(context),
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
        if (!isEmpty || chatPro.attachments.isNotEmpty)
          IconButton(
            icon:chatPro.isLoading ? const CircularProgressIndicator(): const Icon(Icons.send_outlined),
            onPressed: () async {
if (!chatPro.isLoading ) {
                await chatPro.sendMessage(context);
}            },
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
