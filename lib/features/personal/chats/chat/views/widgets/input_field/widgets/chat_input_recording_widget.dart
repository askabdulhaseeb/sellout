import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:voice_note_kit/voice_note_kit.dart';
import '../../../providers/chat_provider.dart';

class ChatInputRecordingWidget extends StatelessWidget {

  const ChatInputRecordingWidget({
    required this.onSend, required this.onCancel, super.key,
  });
  final Function(File file) onSend;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: VoiceRecorderWidget(
        iconSize: 90,
        iconColor: Colors.white,
        backgroundColor: Colors.teal,
        showTimerText: true,
        showSwipeLeftToCancel: true,
        maxRecordDuration: const Duration(seconds: 60),
        permissionNotGrantedMessage: 'Microphone permission required',
        dragToLeftText: 'Swipe left to cancel recording',
        cancelDoneText: 'Recording cancelled',
        cancelHintColor: Colors.red,
        timerFontSize: 16,

        onRecorded: (File file) {
          HapticFeedback.vibrate();
          onSend(file); // send the recorded audio
          Provider.of<ChatProvider>(context, listen: false).stopRecording();
        },

        actionWhenCancel: () {
          onCancel();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recording Cancelled')),
          );
          Provider.of<ChatProvider>(context, listen: false).stopRecording();
        },

        onError: (String error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        },

        onRecordedWeb: (String url) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Web audio recorded: $url')),
          );
        },
      ),
    );
  }
}
