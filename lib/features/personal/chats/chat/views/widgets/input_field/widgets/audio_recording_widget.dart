import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../providers/chat_provider.dart';

class AudioRecordingWidget extends StatefulWidget {
  const AudioRecordingWidget({super.key});

  @override
  State<AudioRecordingWidget> createState() => _AudioRecordingWidgetState();
}

class _AudioRecordingWidgetState extends State<AudioRecordingWidget> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final RecorderController _recorderController = RecorderController();

  bool _isRecorderInitialized = false;
  bool _isRecording = false;
  bool _isPaused = false;
  bool _isSending = false;

  String? _recordedFilePath;
  Duration recordDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission is required')),
        );
      }
      return;
    }

    await _recorder.openRecorder();
    _isRecorderInitialized = true;

    _recorder.setSubscriptionDuration(const Duration(milliseconds: 50));
    _recorder.onProgress?.listen((event) {
      if (mounted && _isRecording && !_isPaused) {
        setState(() {
          recordDuration = event.duration;
        });
      }
    });

    setState(() {});
  }

  Future<void> _pauseResumeRecording() async {
    if (!_isRecorderInitialized || !_isRecording) return;

    try {
      if (_isPaused) {
        await _recorder.resumeRecorder();
      } else {
        await _recorder.pauseRecorder();
      }
      setState(() => _isPaused = !_isPaused);
    } catch (e) {
      _showError('Pause/Resume error: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecorderInitialized || !_isRecording) return;

    try {
      await _recorder.stopRecorder();
      setState(() {
        _isRecording = false;
        _isPaused = false;
      });
    } catch (e) {
      _showError('Stop recording error: $e');
    }
  }

  Future<void> _deleteRecording() async {
    if (_isRecording) await _stopRecording();

    if (_recordedFilePath != null) {
      final file = File(_recordedFilePath!);
      if (await file.exists()) {
        await file.delete();
      }
    }

    _recordedFilePath = null;
    recordDuration = Duration.zero;

    if (mounted) setState(() {});
    context.read<ChatProvider>().setRecording(false);
  }

  Future<void> _sendRecording() async {
    if (_isSending) return;
    if (_isRecording) await _stopRecording();

    if (_recordedFilePath == null) {
      _showError('No recording to send');
      return;
    }

    setState(() => _isSending = true);

    try {
      final chatProvider = context.read<ChatProvider>();
      chatProvider.clearAttachments();
      chatProvider.addAttachment(PickedAttachment(
        file: File(_recordedFilePath!),
        type: AttachmentType.audio,
        selectedMedia: null,
      ));

      await chatProvider.sendMessage(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio sent successfully')),
      );

      await _deleteRecording();
    } catch (e) {
      _showError('Failed to send audio: $e');
    } finally {
      if (mounted) setState(() => _isSending = false);
      context.read<ChatProvider>().setRecording(false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          DeleteButton(
            isRecording: _isRecording,
            isSending: _isSending,
            filePath: _recordedFilePath,
            onDelete: _deleteRecording,
          ),
          const SizedBox(width: 8),
          PauseResumeButton(
            isRecording: _isRecording,
            isPaused: _isPaused,
            isSending: _isSending,
            onTap: _pauseResumeRecording,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AudioWaveforms(
              enableGesture: false,
              size: const Size(double.infinity, 50),
              recorderController: _recorderController,
              waveStyle: const WaveStyle(
                waveColor: Colors.teal,
                extendWaveform: true,
                showMiddleLine: false,
                spacing: 6,
                scaleFactor: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SendButton(
            isRecording: _isRecording,
            isSending: _isSending,
            filePath: _recordedFilePath,
            onSend: _sendRecording,
          ),
        ],
      ),
    );
  }
}
class SendButton extends StatelessWidget {
  final bool isRecording;
  final bool isSending;
  final String? filePath;
  final VoidCallback onSend;

  const SendButton({
    super.key,
    required this.isRecording,
    required this.isSending,
    required this.filePath,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: isSending
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.send, color: Colors.teal),
      onPressed: (filePath == null || isSending) ? null : onSend,
    );
  }
}

class DeleteButton extends StatelessWidget {

  const DeleteButton({
    super.key,
    required this.isRecording,
    required this.isSending,
    required this.filePath,
    required this.onDelete,
  });
  final bool isRecording;
  final bool isSending;
  final String? filePath;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: (isSending || filePath == null) ? null : onDelete,
    );
  }
}

class PauseResumeButton extends StatelessWidget {
  final bool isRecording;
  final bool isPaused;
  final bool isSending;
  final VoidCallback onTap;

  const PauseResumeButton({
    super.key,
    required this.isRecording,
    required this.isPaused,
    required this.isSending,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!isRecording) return const SizedBox.shrink();

    return IconButton(
      icon: Icon(
        isPaused ? Icons.play_arrow : Icons.pause,
        color: Colors.black,
      ),
      onPressed: isSending ? null : onTap,
    );
  }
}
