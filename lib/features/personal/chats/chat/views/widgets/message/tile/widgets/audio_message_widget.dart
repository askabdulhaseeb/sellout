import 'package:flutter/material.dart';
import 'package:voice_note_kit/player/utils/audio_player_controller.dart';
import 'package:voice_note_kit/voice_note_kit.dart';
import '../../../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';

class AudioMessageWidget extends StatefulWidget {
  const AudioMessageWidget({required this.message, super.key});
  final MessageEntity message;

  @override
  State<AudioMessageWidget> createState() => _AudioMessageWidgetState();
}

class _AudioMessageWidgetState extends State<AudioMessageWidget> {
  late final VoiceNotePlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VoiceNotePlayerController();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMe = widget.message.sendBy == LocalAuth.uid;
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return PopScope(
      onPopInvokedWithResult:(bool didPop, dynamic result) => controller.dispose(),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: AudioPlayerWidget(
          controller: controller,
          timerTextStyle: textTheme.labelMedium,
          autoPlay: false,
          autoLoad: true,
          audioPath: widget.message.fileUrl[0].url,
          audioType: AudioType.url,
          playerStyle: PlayerStyle.style5,
          textDirection: TextDirection.ltr,
          size: 30,
          backgroundColor: Colors.transparent,
          progressBarHeight: 50,
          progressBarColor: !isMe
              ? AppTheme.primaryColor
              : colorScheme.secondary.withValues(alpha:0.8),
          progressBarBackgroundColor: !isMe
              ? AppTheme.primaryColor.withValues(alpha:0.2)
              : colorScheme.secondary.withValues(alpha:0.1),
          iconColor: !isMe ? AppTheme.primaryColor : colorScheme.secondary,
          shapeType: PlayIconShapeType.circular,
          showProgressBar: true,
          showTimer: true,
          width: 280,
          audioSpeeds: const <double>[0.01, 0.02, 0.03, 0.04],

          // Debug Callbacks
          onSeek: (double value) => debugPrint('Seeked to: $value'),
          onError: (String msg) => debugPrint('Error: $msg'),
          onPause: () => debugPrint('Paused'),
          onPlay: (bool playing) => debugPrint('Playing: $playing'),
          onSpeedChange: (double speed) => debugPrint('Speed: $speed'),
        ),
      ),
    );
  }
}
