import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/video_widget.dart';
import '../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../providers/chat_provider.dart';
import 'widgets/chat_field_Attachment_menu.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

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
              final bool isRecording = chatPro.isRecording;
              return Column(
                children: <Widget>[
                  if (chatPro.attachments.isNotEmpty)
                    ChatAttachmentsListView(
                      attachments: chatPro.attachments,
                    ),
                  Row(
                    children: <Widget>[
                      if (!isRecording) const AttachmentMenuButton(),
                      if (isRecording) _buildStopButton(context, chatPro),
                      Expanded(
                        child: isRecording
                            ? _buildRecordingUI(chatPro)
                            : TextFormField(
                                controller: chatPro.message,
                                minLines: 1,
                                maxLines: 5,
                                onChanged: (String value) =>
                                    chatPro.onTextChange(value),
                                decoration:
                                    _buildInputDecoration(context, chatPro),
                              ),
                      ),
                      if (isRecording) _buildTimer(chatPro),
                      _buildActionButton(context, chatPro),
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

  Widget _buildStopButton(BuildContext context, ChatProvider chatPro) {
    return IconButton(
      icon: const Icon(Icons.stop, color: Colors.red),
      onPressed: () async {
        final String? path = await chatPro.stopRecording();
        if (path != null) {
          chatPro.addAttachment(PickedAttachment(
            file: File(path),
            type: AttachmentType.audio,
          ));
        }
      },
    );
  }

  Widget _buildRecordingUI(ChatProvider chatPro) {
    return Column(
      children: <Widget>[
        AudioWaveforms(
          size: const Size(double.infinity, 40),
          recorderController: chatPro.recorderController,
          waveStyle: const WaveStyle(
            waveColor: Colors.blue,
            spacing: 8.0,
            showBottom: false,
            extendWaveform: true,
          ),
        ),
      ],
    );
  }

  Widget _buildTimer(ChatProvider chatPro) {
    return StreamBuilder<Duration>(
      stream: chatPro.recorderController.onCurrentDuration,
      builder: (BuildContext context, AsyncSnapshot<Duration> snapshot) {
        final Duration duration = snapshot.data ?? Duration.zero;
        final String minutes =
            duration.inMinutes.remainder(60).toString().padLeft(2, '0');
        final String seconds =
            duration.inSeconds.remainder(60).toString().padLeft(2, '0');
        return Text('$minutes:$seconds',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface));
      },
    );
  }

  InputDecoration _buildInputDecoration(
      BuildContext context, ChatProvider chatPro) {
    return InputDecoration(
      hintText: 'your_message_here'.tr(),
      border: InputBorder.none,
    );
  }

  Widget _buildActionButton(BuildContext context, ChatProvider chatPro) {
    return IconButton(
      icon: Icon(
        chatPro.isRecording
            ? Icons.mic_off
            : chatPro.message.text.isEmpty
                ? Icons.mic
                : Icons.send,
        color: chatPro.isRecording ? Colors.red : null,
      ),
      onPressed: () async {
        if (chatPro.isRecording) {
          await chatPro.stopRecording();
        } else if (chatPro.message.text.isNotEmpty) {
          await chatPro.sendMessage(context);
        } else {
          await chatPro.startRecording(context);
        }
      },
    );
  }
}

class ChatAttachmentsListView extends StatelessWidget {
  const ChatAttachmentsListView({required this.attachments, super.key});
  final List<PickedAttachment> attachments;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: attachments.length,
        itemBuilder: (BuildContext context, int index) {
          final PickedAttachment attachment = attachments[index];
          return CustomMediaTile(media: attachment);
        },
      ),
    );
  }
}

class CustomMediaTile extends StatelessWidget {
  const CustomMediaTile({required this.media, super.key});
  final PickedAttachment media;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
      margin: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: media.type == AttachmentType.image
            ? Image.file(
                media.file,
                fit: BoxFit.cover,
              )
            : VideoWidget(
                fit: BoxFit.cover,
                showTime: true,
                videoSource: media.file.path,
                play: false,
              ),
      ),
    );
  }
}
