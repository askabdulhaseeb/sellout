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
    return MessageBgWidget(
      color: Colors.grey,
      height: 40,
      isMe: message.sendBy == LocalAuth.uid,
      child: Consumer<AudioProvider>(
          builder: (BuildContext context, AudioProvider play, _) {
        // return AudioWaveforms(
        //   size: MediaQuery.sizeOf(context),
        //   recorderController: play.recoder,
        //   waveStyle: WaveStyle(
        //     waveColor: Colors.white,
        //     showDurationLabel: true,
        //     spacing: 8.0,
        //     showBottom: false,
        //     extendWaveform: true,
        //     showMiddleLine: false,
        //     gradient: ui.Gradient.linear(
        //       const Offset(70, 50),
        //       Offset(MediaQuery.of(context).size.width / 2, 0),
        //       [Colors.white, Colors.green],
        //     ),
        //   ),
        // );
        return const Text('Autio');
      }),
    );
  }
}
