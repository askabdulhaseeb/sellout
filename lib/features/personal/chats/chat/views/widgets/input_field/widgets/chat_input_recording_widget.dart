import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

import '../../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../providers/chat_provider.dart';

class SwipeToRecordWidget extends StatefulWidget {
  const SwipeToRecordWidget({super.key});

  @override
  State<SwipeToRecordWidget> createState() => _SwipeToRecordWidgetState();
}

class _SwipeToRecordWidgetState extends State<SwipeToRecordWidget>
    with SingleTickerProviderStateMixin {
  final AudioRecorder _recorder = AudioRecorder();
  String? filePath;
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  Timer? _timer;
  int _recordDuration = 0;
  bool isSending = false;

  ChatProvider get chatPro => Provider.of<ChatProvider>(context, listen: false);//Exception has occurred.FlutterError (This widget has been unmounted, so the State no longer has a context (and should be considered defunct).Consider canceling any active work during "dispose" or using the "mounted" getter to determine if the State is still active.)

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _startRecording();
  }

  Future<void> _startRecording() async {
    final bool hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      await Permission.microphone.request();
      return;
    }

    final Directory dir = await getTemporaryDirectory();
    final String path = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.wav';

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.wav),
      path: path,
    );

    filePath = path;
    _controller.repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _recordDuration++);
    });
  }

  Future<void> _stopRecording() async {
    _controller.stop();
    _timer?.cancel();
    await _recorder.stop();
    if (!mounted) return;
Provider.of<ChatProvider>(context, listen: false).stopRecording();

  }

 Future<void> _sendRecording() async {
  if (filePath == null || isSending) return;
  _controller.stop();
  _timer?.cancel();

  setState(() {
    isSending = true;
  });

  final String? path = await _recorder.stop();
  if (path == null) {
    setState(() {
      isSending = false;
    });
    return;
  }

  final PickedAttachment attachment = PickedAttachment(
    file: File(path),
    type: AttachmentType.audio,
  );

if (!mounted) return;

final ChatProvider chatPro = Provider.of<ChatProvider>(context, listen: false);
chatPro.addAttachment(attachment);
await chatPro.sendMessage(context);
chatPro.stopRecording();
  setState(() {
    isSending = false;
  });
}

  String _formatDuration(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remaining = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remaining.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PopScope(
        onPopInvokedWithResult: (bool didPop, dynamic result) =>
_stopRecording(),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: _stopRecording,
              child: Container(
                decoration:  BoxDecoration(
                  color: ColorScheme.of(context).error,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child:  Icon(
                  Icons.stop,
                  color: ColorScheme.of(context).onPrimary,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Text(
              _formatDuration(_recordDuration),
              style:TextTheme.of(context).bodyLarge
            ),
            const SizedBox(width: 20),
            isSending
                ? const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                    ),
                  )
                : AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (_, __) {
                      return GestureDetector(
                        onTap: _sendRecording,
                        child: Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            decoration:  BoxDecoration(
                              color:ColorScheme.of(context).secondary,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(12),
                            child:  Icon(
                              Icons.send,
                              color:ColorScheme.of(context).onSecondary,
                  size: 20,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
