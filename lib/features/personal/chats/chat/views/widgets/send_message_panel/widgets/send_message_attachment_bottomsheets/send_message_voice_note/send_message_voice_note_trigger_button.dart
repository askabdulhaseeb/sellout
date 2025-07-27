import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import '../../../../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../../providers/send_message_provider.dart';

class VoiceRecordTrigger extends StatefulWidget {
  const VoiceRecordTrigger({super.key});

  @override
  State<VoiceRecordTrigger> createState() => _VoiceRecordTriggerState();
}

class _VoiceRecordTriggerState extends State<VoiceRecordTrigger> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  late SendMessageProvider msgPro;

  late final RecorderController _waveformController;
  final GlobalKey _deleteKey = GlobalKey();

  Offset micOffset = Offset.zero;
  String? _recordPath;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _isDisposed = false;
    _initializeRecorder();
    _waveformController = RecorderController();
  }

  Future<void> _initializeRecorder() async {
    try {
      await _recorder.openRecorder();
      await _recorder
          .setSubscriptionDuration(const Duration(milliseconds: 100));
    } catch (e) {
      debugPrint('Recorder initialization error: $e');
    }
  }

  Future<void> _playSound(String assetPath) async {
    final AudioPlayer player = AudioPlayer();
    try {
      await player.setAsset(assetPath);
      await player.play();
    } catch (e) {
      debugPrint('Sound playback error: $e');
    } finally {
      await player.dispose();
    }
  }

  Future<void> _startRecording() async {
    if (_isDisposed) return;
    try {
      msgPro.startRecording();
      await _playSound(AppStrings.recordingStartSound);
      final Directory dir = await getApplicationDocumentsDirectory();
      _recordPath =
          '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';
      _waveformController
        ..refresh()
        ..record();
      await _recorder.startRecorder(toFile: _recordPath);

      if (!_isDisposed) {
        setState(() => msgPro.isRecordingAudio.value = true);
      }
    } catch (e) {
      debugPrint('Recording start error: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      // Stop recording
      if (_recorder.isRecording) {
        await _recorder.stopRecorder();
        final SendMessageProvider msgPro =
            Provider.of<SendMessageProvider>(context, listen: false);
        msgPro.stopRecording();
        await _playSound(AppStrings.recordingShareSound);
      }

      final SendMessageProvider msgPro =
          Provider.of<SendMessageProvider>(context, listen: false);
      if (_recordPath != null) {
        final File file = File(_recordPath!);
        if (await file.exists()) {
          msgPro.addAttachment(
            PickedAttachment(file: file, type: AttachmentType.audio),
          );
          msgPro.sendMessage(context);
        }
      }
    } catch (e) {
      debugPrint('Recording stop error: $e');
    } finally {
      // Reset state
      _resetRecordingState();
    }
  }

  Future<void> _deleteRecording() async {
    try {
      // Stop recording
      if (_recorder.isRecording) {
        await _recorder.stopRecorder();
        final SendMessageProvider msgPro =
            Provider.of<SendMessageProvider>(context, listen: false);
        msgPro.stopRecording();
      }

      // Play delete sound
      await _playSound(AppStrings.recordingDeleteSound);

      // Process deletion

      if (_recordPath != null) {
        final File file = File(_recordPath!);
        if (await file.exists()) await file.delete();
      }
    } catch (e) {
      debugPrint('Deletion error: $e');
    } finally {
      // Reset state
      _resetRecordingState();
    }
  }

  void _resetRecordingState() {
    if (_isDisposed) return;

    setState(() {
      msgPro.isRecordingAudio.value = false;
      micOffset = Offset.zero;
      _recordPath = null;
    });

    // Reset waveform
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed) {
        _waveformController.reset();
      }
    });
  }

  bool _isOverDeleteZone(Offset globalPosition) {
    final BuildContext? context = _deleteKey.currentContext;
    if (context == null) return false;

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return false;

    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    final Rect rect = Rect.fromLTWH(
      position.dx,
      position.dy,
      size.width,
      size.height,
    );
    return rect.contains(globalPosition);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _recorder.closeRecorder();
    _waveformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          /// 🗑️ Trash delete zone
          if (msgPro.isRecordingAudio.value)
            Positioned(
              top: 0,
              left: 10,
              bottom: 0,
              child: AnimatedContainer(
                key: _deleteKey,
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withOpacity(
                        _isOverDeleteZone(micOffset) ? 0.4 : 0.05,
                      ),
                  shape: BoxShape.circle,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(scale: animation, child: child),
                    );
                  },
                  child: _isOverDeleteZone(micOffset)
                      ? Icon(Icons.delete_forever_rounded,
                          key: const ValueKey('delete_forever'),
                          color: Theme.of(context).colorScheme.error,
                          size: 36)
                      : Icon(Icons.delete_outline_rounded,
                          key: const ValueKey('delete_outline'),
                          color: Theme.of(context).colorScheme.error,
                          size: 36),
                ),
              ),
            ),

          /// 📈 Audio waveform
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: msgPro.isRecordingAudio.value
                ? Positioned(
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 70),
                      child: AudioWaveforms(
                        size: const Size(double.infinity, 40),
                        recorderController: _waveformController,
                        waveStyle: const WaveStyle(
                          labelSpacing: 0.1,
                          waveThickness: 4,
                          waveColor: AppTheme.secondaryColor,
                          extendWaveform: true,
                          showMiddleLine: false,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          /// 🎤 Mic button
          Positioned(
            right: 10,
            bottom: 0,
            top: 0,
            child: GestureDetector(
              onLongPressStart: (_) async {
                if (_isDisposed) return;
                setState(() => msgPro.isRecordingAudio.value = true);
                await _startRecording();
              },
              onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
                if (_isDisposed) return;
                setState(() => micOffset = details.offsetFromOrigin);
              },
              onLongPressEnd: (LongPressEndDetails details) async {
                if (_isDisposed) return;

                if (_isOverDeleteZone(details.globalPosition)) {
                  await _deleteRecording();
                } else {
                  await _stopRecording();
                }
              },
              child: Transform.translate(
                offset: micOffset,
                child: Container(
                  padding:
                      EdgeInsets.all(msgPro.isRecordingAudio.value ? 16 : 0),
                  decoration: BoxDecoration(
                    color: msgPro.isRecordingAudio.value
                        ? AppTheme.secondaryColor
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mic_none_outlined,
                    color: msgPro.isRecordingAudio.value
                        ? Theme.of(context).colorScheme.onSecondary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
