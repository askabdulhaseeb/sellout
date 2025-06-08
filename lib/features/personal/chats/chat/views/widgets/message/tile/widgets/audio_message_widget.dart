import 'package:flutter/material.dart';
import 'package:voice_note_kit/voice_note_kit.dart';
import '../../../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';

class AudioMessageWidget extends StatelessWidget {
  const AudioMessageWidget({required this.message, super.key});
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.sendBy == LocalAuth.uid;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: AudioPlayerWidget(
        timerTextStyle: TextTheme.of(context).labelMedium,
        autoPlay: false,
        autoLoad: true,
        audioPath: message.fileUrl[0].url,
        audioType: AudioType.url,
        playerStyle: PlayerStyle.style5, 
        textDirection: TextDirection.ltr,
        size: 30,backgroundColor: Colors.transparent,
        progressBarHeight: 50,
        progressBarColor: AppTheme.primaryColor,
        progressBarBackgroundColor:AppTheme.primaryColor.withValues(alpha: 0.2),
        iconColor:    ColorScheme.of(context).secondary,
        shapeType: PlayIconShapeType.circular,
        showProgressBar: true,
        showTimer: true,
        width: 280,
        audioSpeeds: const <double>[0.01, 0.02, 0.03, 0.04],
        onSeek: (double value) => debugPrint('Seeked to: $value'),
        onError: (String message) => debugPrint('Error: $message'),
        onPause: () => debugPrint('Paused'),
        onPlay: (bool isPlaying) => debugPrint('Playing: $isPlaying'),
        onSpeedChange: (double speed) => debugPrint('Speed: $speed'),
      ),
    );
  }
}
