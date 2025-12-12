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

  // Fixed width for attachment menu button to maintain consistent layout
  static const double _attachmentButtonWidth = 36.0;

  @override
  Widget build(BuildContext context) {
    final SendMessageProvider msgPro = Provider.of<SendMessageProvider>(
      context,
    );

    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        msgPro.stopRecording();
        msgPro.closeAllMenus();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Main input area with padding
              Padding(
                padding: const EdgeInsets.all(8),
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
                            attachments: msgPro.attachments,
                          ),
                        ValueListenableBuilder<bool>(
                          valueListenable: msgPro.isRecordingAudio,
                          builder: (BuildContext context, bool isRecording, _) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                // Reserve space for attachment button to prevent layout shift
                                if (!isRecording)
                                  AnimatedContainer(
                                    duration: const Duration(
                                      milliseconds: 200,
                                    ),
                                    width: hasText
                                        ? 0
                                        : _attachmentButtonWidth,
                                    child: hasText
                                        ? const SizedBox.shrink()
                                        : const SendMessageAttachmentMenuButton(),
                                  ),
                                if (!isRecording)
                                  const EmojiPickerIconButton(),
                                if (!isRecording)
                                  const Expanded(
                                    child: SendMessageFIeld(),
                                  ),
                                if (isRecording)
                                  const Expanded(
                                    child: VoiceRecordTrigger(),
                                  )
                                else ...<Widget>[
                                  const SizedBox(width: 8),
                                  if (hasText || haveAttachments)
                                    const SendMessageButton()
                                  else
                                    const VoiceRecordTrigger(),
                                ],
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              // Inline emoji picker below the input field
              const InlineEmojiPicker(),
            ],
          ),
        ),
      ),
    );
  }
}
