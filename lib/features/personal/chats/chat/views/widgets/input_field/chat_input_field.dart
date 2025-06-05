import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../providers/chat_provider.dart';
import 'widgets/audio_recording_widget.dart';
import 'widgets/chat_field_Attachment_menu.dart';
import 'widgets/chat_field_attachment_slider.dart';

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
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Consumer<ChatProvider>(
            builder: (BuildContext context, ChatProvider chatPro, _) {
              return Column(
                children: <Widget>[
                  if (chatPro.attachments.isNotEmpty &&
                      chatPro.attachments.first.type != AttachmentType.audio)
                    ChatAttachmentsListView(attachments: chatPro.attachments),
                  // If recording is active or paused, show the audio UI
                  if (chatPro.isRecording)
                    const AudioRecordingWidget(),
                  // Otherwise show text input
                   if (!chatPro.isRecording)    Row(
                      children: <Widget>[ 
                       const  AttachmentMenuButton(),
                        Expanded(
                          child: TextFormField(
                            controller: chatPro.message,
                            minLines: 1,
                            maxLines: 5,
                            onChanged: (String value) =>
                                chatPro.onTextChange(value),
                            decoration: const InputDecoration(
                              hintText: 'your_message_here',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            chatPro.message.text.isEmpty
                                ? Icons.mic
                                : Icons.send,
                          ),
                          onPressed: () async {
                            if (chatPro.message.text.isNotEmpty) {
                              await chatPro.sendMessage(context);
                            } else {
                              //  chatPro.startRecording();
                            }
                          },
                        ),
                      ],
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
