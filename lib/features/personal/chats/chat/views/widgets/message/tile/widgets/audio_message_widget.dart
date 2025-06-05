import 'dart:ui' as ui;

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../../providers/audio_provider.dart';
import '../../message_bg_widget.dart';

class AudioMessaheWidget extends StatelessWidget {
  const AudioMessaheWidget({required this.message, super.key});
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    final String? audioFilePath = message.fileUrl.isNotEmpty ? message.fileUrl[0].url : null;

    if (audioFilePath == null) {
      return const SizedBox(
        height: 40,
        child: Center(child: Text('No audio file')),
      );
    }

    return MessageBgWidget(
      color: Colors.grey,
      height: 60,
      isMe: message.sendBy == LocalAuth.uid,
      child: Consumer<AudioProvider>(
        builder: (BuildContext context, AudioProvider audioProvider, _) {
          final bool isPlaying = audioProvider.isPlaying(audioFilePath);

          return Row(
            children: <Widget>[
              // Play/Pause button
              IconButton(
                icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill, color: Colors.white),
                iconSize: 32,
                onPressed: () {
                  audioProvider.togglePlaying(audioFilePath);
                },
              ),

              // Waveform
              Expanded(
                child: AudioWaveforms(
                  size: const Size(double.infinity, 40),
                  recorderController: audioProvider.recorderController,
                  waveStyle: WaveStyle(
                    waveColor: Colors.white,
                    showDurationLabel: false,
                    spacing: 6.0,
                    showBottom: false,
                    extendWaveform: true,
                    showMiddleLine: false,
                    gradient: ui.Gradient.linear(
                      const Offset(0, 0),
                      Offset(MediaQuery.of(context).size.width / 2, 0),
                      <ui.Color>[Colors.white, Colors.green],
                    ),
                  ),
                ),
              ),

              // Optional: Show a simple play/pause label or duration later
              // SizedBox(width: 8),
              // Text(isPlaying ? 'Playing' : 'Paused', style: TextStyle(color: Colors.white)),
            ],
          );
        },
      ),
    );
  }
}
