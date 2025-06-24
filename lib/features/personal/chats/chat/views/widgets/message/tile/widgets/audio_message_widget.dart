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
  VoiceNotePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(covariant AudioMessageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message.fileUrl[0].url != widget.message.fileUrl[0].url) {
      _disposeController();
      _initController();
    }
  }

  void _initController() {
    _controller = VoiceNotePlayerController();
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMe = widget.message.sendBy == LocalAuth.uid;
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: AudioPlayerWidget(
        controller: _controller!,
        timerTextStyle: textTheme.labelMedium,
        autoPlay: false,
        autoLoad: true,
        audioPath: widget.message.fileUrl[0].url,
        audioType: AudioType.url,
        playerStyle: PlayerStyle.style5,
        textDirection: TextDirection.ltr,
        size: 30,
        backgroundColor: Colors.transparent,
        progressBarHeight: 100,
        progressBarColor: !isMe ? AppTheme.primaryColor : colorScheme.secondary,
        progressBarBackgroundColor: !isMe
            ? AppTheme.primaryColor.withValues(alpha: 0.5)
            : colorScheme.secondary.withValues(alpha: 0.5),
        iconColor: !isMe ? AppTheme.primaryColor : colorScheme.secondary,
        shapeType: PlayIconShapeType.circular,
        showProgressBar: true,
        showSpeedControl: true,
        width: 280,
        audioSpeeds: const <double>[0.25, 0.5, 1, 1.5, 1.75, 2],
        onSeek: (double value) => debugPrint('Seeked to: $value'),
        onError: (String msg) => debugPrint('Error: $msg'),
        onSpeedChange: (double speed) => debugPrint('Speed: $speed'),
      ),
    );
  }
}
