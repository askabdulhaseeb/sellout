import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:voice_note_kit/recorder/voice_enums/voice_enums.dart';
import 'package:voice_note_kit/voice_note_kit.dart';
import '../../../providers/chat_provider.dart';

class ChatInputRecordingWidget extends StatelessWidget {
  const ChatInputRecordingWidget({
    required this.onSend,
    required this.onCancel,
    super.key,
  });

  final Function(File file) onSend;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: VoiceRecorderWidget(
        style: VoiceUIStyle.compact,
        enableHapticFeedback: true,
        iconSize: 90,
        iconColor: Colors.white,
        backgroundColor: Colors.teal,
        showTimerText: true,
        showSwipeLeftToCancel: true,
        maxRecordDuration: const Duration(seconds: 60),
        permissionNotGrantedMessage: 'microphone_permission_required'.tr(),
        dragToLeftText: 'swipe_cancel_recording'.tr(),
        cancelDoneText: 'recording_cancelled'.tr(),
        cancelHintColor: Colors.red,
        timerFontSize: 16,

      onRecorded: (File file) {
  HapticFeedback.vibrate();
  debugPrint('📁 Audio file recorded: ${file.path}');
  debugPrint('📦 File exists: ${file.existsSync()}');
  debugPrint('📏 File size: ${file.lengthSync()} bytes');
  onSend(file); // your function to use the file (like sending or playing)
  Provider.of<ChatProvider>(context, listen: false).stopRecording();
},

        actionWhenCancel: () {
          onCancel();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('recording_cancelled'.tr())),
          );
          Provider.of<ChatProvider>(context, listen: false).stopRecording();
        },

        onError: (String error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('something_wrong'.tr())),
          );
        },

        onRecordedWeb: (String url) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('web_audio_recorded'.tr())),
          );
        },
      ),
    );
  }
}
