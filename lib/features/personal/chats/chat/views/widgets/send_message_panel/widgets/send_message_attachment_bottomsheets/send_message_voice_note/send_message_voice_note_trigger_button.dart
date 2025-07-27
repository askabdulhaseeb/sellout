import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../../../../../../../../../../core/theme/app_theme.dart';
import '../../../../../providers/send_message_provider.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class VoiceRecordTrigger extends StatefulWidget {
  const VoiceRecordTrigger({super.key});

  @override
  State<VoiceRecordTrigger> createState() => _VoiceRecordTriggerState();
}

class _VoiceRecordTriggerState extends State<VoiceRecordTrigger> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  late final RecorderController _waveformController;

  final GlobalKey _deleteKey = GlobalKey();
  Offset micOffset = Offset.zero;
  bool isRecording = false;
  String? _recordPath;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    await _recorder.openRecorder();
    await _recorder.setSubscriptionDuration(const Duration(milliseconds: 100));
    _waveformController = RecorderController();
  }

  Future<void> _startRecording() async {
    final SendMessageProvider msgPro =
        Provider.of<SendMessageProvider>(context, listen: false);
    msgPro.startRecording();
    try {
      final Directory dir = await getApplicationDocumentsDirectory();
      _recordPath =
          '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';
      _waveformController.refresh();
      _waveformController.record();
      await _recorder.startRecorder(toFile: _recordPath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start recording: $e')),
      );
    }
  }

  Future<void> _stopRecording() async {
    final SendMessageProvider msgPro =
        Provider.of<SendMessageProvider>(context, listen: false);
    msgPro.stopRecording();
    try {
      await _recorder.stopRecorder();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to stop recording: $e')),
      );
    }
    _waveformController.stop();
  }

  void _deleteRecording() async {
    final SendMessageProvider msgPro =
        Provider.of<SendMessageProvider>(context, listen: false);
    msgPro.stopRecording();
    try {
      if (_recordPath != null) {
        final File file = File(_recordPath!);
        if (await file.exists()) {
          await file.delete();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recording deleted')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete: $e')),
      );
    }
    _waveformController.stop();
  }

  bool _isOverDeleteZone(Offset globalPosition) {
    final RenderBox renderBox =
        _deleteKey.currentContext?.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    final Rect rect =
        Rect.fromLTWH(position.dx, position.dy, size.width, size.height);
    return rect.contains(globalPosition);
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final msgPro = Provider.of<SendMessageProvider>(context, listen: false);
    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Delete Icon
          // Replace the DragTarget widget inside your Stack with this:

          Positioned(
            top: 16,
            left: 10,
            bottom: 16,
            child: isRecording
                ? AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: ColorScheme.of(context).error.withValues(
                              alpha: _isOverDeleteZone(micOffset) ? 100 : 10)),
                      child: _isOverDeleteZone(micOffset)
                          ? Icon(Icons.delete_forever_rounded,
                              key: const ValueKey('delete_forever'),
                              color: Theme.of(context).colorScheme.error,
                              size: 36)
                          : Icon(Icons.delete_outline_rounded,
                              key: const ValueKey('delete_outline'),
                              color: Theme.of(context).colorScheme.error,
                              size: 36),
                    ))
                : const SizedBox.shrink(),
          ),

          Positioned(
              child: isRecording
                  ? Container(
                      height: 50,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 70),
                      child: AudioWaveforms(
                        size: const Size(double.infinity, 40),
                        recorderController: _waveformController,
                        waveStyle: const WaveStyle(
                          labelSpacing: 0.1,
                          waveThickness: 4,
                          waveColor: AppTheme.primaryColor,
                          extendWaveform: true,
                          showMiddleLine: false,
                        ),
                      ),
                    )
                  : const SizedBox.shrink()),
          Positioned(
            right: 10,
            bottom: 0,
            top: 0,
            child: GestureDetector(
              onLongPressStart: (_) async {
                setState(() {
                  isRecording = true;
                });
                await _startRecording();
              },
              onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
                setState(() {
                  micOffset = details.offsetFromOrigin;
                });
              },
              onLongPressEnd: (LongPressEndDetails details) async {
                setState(() {
                  isRecording = false;
                  micOffset = Offset.zero;
                });

                if (_isOverDeleteZone(details.globalPosition)) {
                  _deleteRecording();
                } else {
                  await _stopRecording();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('recording_saved')),
                  );
                }
              },
              child: Transform.translate(
                offset: micOffset,
                child: Container(
                    padding: EdgeInsets.all(isRecording ? 16 : 0),
                    decoration: BoxDecoration(
                      color: isRecording
                          ? AppTheme.primaryColor
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.mic_none_outlined,
                        color: isRecording
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
