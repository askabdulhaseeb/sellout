import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/send_message_provider.dart';
import 'widgets/send_message_attachment_bottomsheets/send_message_emogi_picker_bottomsheet.dart';
import 'widgets/send_message_attachment_menu/subwidgets/send_message_panel_attachments_list.dart';
import 'widgets/send_message_voice_note/send_message_voice_note_trigger_button.dart';
import 'widgets/send_message_attachment_menu/send_message_attachment_menu_button.dart';
import 'widgets/send_message_button.dart';
import 'widgets/send_message_field.dart';

class SendMessagePanel extends StatelessWidget {
  const SendMessagePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final SendMessageProvider msgPro =
        Provider.of<SendMessageProvider>(context);

    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) =>
          msgPro.stopRecording(),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Theme.of(context).dividerColor),
        child: ValueListenableBuilder<TextEditingValue>(
          valueListenable: msgPro.message,
          builder: (BuildContext context, TextEditingValue messageValue, _) {
            final bool hasText = messageValue.text.trim().isNotEmpty;
            final bool haveAttachments = msgPro.attachments.isNotEmpty;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (haveAttachments)
                  SendMessagePanelAttachmentsList(
                      attachments: msgPro.attachments),
                ValueListenableBuilder<bool>(
                  valueListenable: msgPro.isRecordingAudio,
                  builder: (BuildContext context, bool isRecording, _) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        if (!isRecording)
                          SizedBox(
                            width: w * 0.8,
                            child: Row(
                              children: <Widget>[
                                if (!hasText)
                                  const SendMessageAttachmentMenuButton(),
                                const EmojiPickerIconButton(),
                                const Expanded(child: SendMessageFIeld()),
                              ],
                            ),
                          ),
                        if (hasText || haveAttachments)
                          const SendMessageButton()
                        else
                          const VoiceRecordTrigger(),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
