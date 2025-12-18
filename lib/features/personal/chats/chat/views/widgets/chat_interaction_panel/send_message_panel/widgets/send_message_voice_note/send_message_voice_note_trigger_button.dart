import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../../../../../../../core/helper_functions/duration_format_helper.dart';
import '../../../../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../../../../core/widgets/custom_icon_button.dart';
import '../../../../../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../../providers/send_message_provider.dart';

class VoiceRecordTrigger extends StatefulWidget {
  const VoiceRecordTrigger({super.key});

  @override
  State<VoiceRecordTrigger> createState() => _VoiceRecordTriggerState();
}

class _VoiceRecordTriggerState extends State<VoiceRecordTrigger> {
  static const String _tag = 'VoiceRecordTrigger';

  void _log(String message) {
    debugPrint('[$_tag] $message');
  }

  // Recorder & waveform
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  late final RecorderController _waveformController;

  StreamSubscription<RecordingDisposition>? _progressSub;
  bool _recorderReady = false;
  bool _isActionInFlight = false;

  // Send message provider
  late final SendMessageProvider _msgPro;

  // State
  bool _isRecording = false;
  String? _recordPath;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();

    _msgPro = Provider.of<SendMessageProvider>(context, listen: false);
    _waveformController = RecorderController();
    _log('initState: starting recorder init');
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    if (_recorderReady) return;
    try {
      final PermissionStatus status = await Permission.microphone.request();
      _log('microphone permission: $status');
      if (!status.isGranted) {
        _log('microphone permission not granted; recorder not ready');
        return;
      }
      await _recorder.openRecorder();
      await _recorder.setSubscriptionDuration(
        const Duration(milliseconds: 100),
      );
      _recorderReady = true;
      _log('recorder initialized successfully');
    } catch (e, st) {
      _log('initializeRecorder ERROR: $e');
      _log('initializeRecorder STACK: $st');
      _recorderReady = false;
    }
  }

  Future<bool> _ensureRecorderReady() async {
    await _initializeRecorder();
    return _recorderReady;
  }

  Future<void> _playSound(String assetPath) async {
    final AudioPlayer player = AudioPlayer();
    try {
      _log('playSound: $assetPath');
      await player.setAsset(assetPath); // Load asset
      await player.play();
      await player.processingStateStream.firstWhere(
        (ProcessingState s) => s == ProcessingState.completed,
      );
    } catch (e) {
      _log('playSound ERROR ($assetPath): $e');
    } finally {
      player.dispose(); // Dispose after playing
    }
  }

  Future<void> _startRecording() async {
    if (_isActionInFlight) return;
    _isActionInFlight = true;

    _log(
      'startRecording: begin (ready=$_recorderReady, isRecording=$_isRecording, recorder.isRecording=${_recorder.isRecording})',
    );

    final bool ready = await _ensureRecorderReady();
    if (!ready) {
      _log('startRecording: recorder not ready; abort');
      _isActionInFlight = false;
      return;
    }

    try {
      final Directory dir = await getApplicationDocumentsDirectory();
      _recordPath =
          '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';
      _log('startRecording: path=$_recordPath');
      await _recorder.startRecorder(toFile: _recordPath, codec: Codec.aacADTS);
      _log('startRecording: recorder started');
    } catch (e, st) {
      _log('startRecording ERROR: $e');
      _log('startRecording STACK: $st');
      _isActionInFlight = false;
      return;
    }

    try {
      _waveformController.record();
    } catch (_) {}

    unawaited(_playSound(AppStrings.recordingStartSound));
    _msgPro.startRecording();
    // Listen to real duration
    await _progressSub?.cancel();
    _progressSub = _recorder.onProgress?.listen((RecordingDisposition event) {
      if (!mounted) return;
      setState(() {
        _duration = event.duration;
      });
    });
    _log('startRecording: progress listener attached=${_progressSub != null}');

    if (mounted) {
      setState(() {
        _isRecording = true;
      });
    }

    _isActionInFlight = false;
    _log('startRecording: done');
  }

  Future<void> _stopRecording() async {
    _log(
      'stopRecording: begin (isRecording=$_isRecording, recorder.isRecording=${_recorder.isRecording}, path=$_recordPath)',
    );
    try {
      await _progressSub?.cancel();
    } catch (e, st) {
      _log('stopRecording: cancel progress ERROR: $e');
      _log('stopRecording: cancel progress STACK: $st');
    }
    _progressSub = null;

    try {
      if (_recorder.isRecording) {
        _log('stopRecording: calling stopRecorder()');
        final String? stoppedPath = await _recorder
            .stopRecorder()
            .timeout(const Duration(seconds: 4));
        _log('stopRecording: stopRecorder returned=$stoppedPath');
        if (stoppedPath != null && stoppedPath.isNotEmpty) {
          _recordPath = stoppedPath;
        }
      } else {
        _log('stopRecording: recorder was not recording');
      }
    } on TimeoutException catch (e, st) {
      _log('stopRecording: stopRecorder TIMEOUT: $e');
      _log('stopRecording: stopRecorder TIMEOUT STACK: $st');
    } catch (e, st) {
      _log('stopRecording ERROR: $e');
      _log('stopRecording STACK: $st');
    }

    try {
      _log('stopRecording: stopping waveform controller');
      await _waveformController
          .stop()
          .timeout(const Duration(seconds: 2));
      _log('stopRecording: waveform controller stopped');
    } on TimeoutException catch (e, st) {
      _log('stopRecording: waveform stop TIMEOUT: $e');
      _log('stopRecording: waveform stop TIMEOUT STACK: $st');
    } catch (e, st) {
      _log('stopRecording: waveform stop ERROR: $e');
      _log('stopRecording: waveform stop STACK: $st');
    }

    _msgPro.stopRecording();
    _log('stopRecording: provider stopRecording called');

    if (mounted) {
      setState(() {
        _isRecording = false;
        _duration = Duration.zero;
      });
    }
    _log('stopRecording: end (path=$_recordPath)');
  }

  Future<void> _sendRecording() async {
    if (_isActionInFlight) return;
    _isActionInFlight = true;
    _log('sendRecording: begin');
    await _stopRecording();
    if (_recordPath != null) {
      final File file = File(_recordPath!);
      try {
        final bool exists = await file.exists();
        _log('sendRecording: file exists=$exists path=$_recordPath');
        if (exists) {
          final int length = await file.length();
          _log('sendRecording: file length=$length bytes');
          if (length == 0) {
            _log('sendRecording: file length is 0; abort');
            _isActionInFlight = false;
            return;
          }
          _msgPro.addVoiceNote(
            PickedAttachment(file: file, type: AttachmentType.audio),
          );
          _log('sendRecording: provider addVoiceNote called');
          unawaited(_playSound(AppStrings.recordingShareSound));
          await _msgPro.sendVoiceNote(context);
          _log('sendRecording: provider sendVoiceNote finished');
        }
      } catch (e, st) {
        _log('sendRecording ERROR: $e');
        _log('sendRecording STACK: $st');
      }
    }
    _recordPath = null;
    _isActionInFlight = false;
    _log('sendRecording: end');
  }

  Future<void> _deleteRecording() async {
    if (_isActionInFlight) return;
    _isActionInFlight = true;

    _log('deleteRecording: begin (path=$_recordPath)');

    await _stopRecording();
    if (_recordPath != null) {
      final File file = File(_recordPath!);
      try {
        final bool exists = await file.exists();
        _log('deleteRecording: file exists=$exists path=$_recordPath');
        if (exists) {
          // Give the OS a moment to release the handle.
          await Future<void>.delayed(const Duration(milliseconds: 80));
          await file.delete();
          _log('deleteRecording: file deleted');
        }
      } catch (e, st) {
        _log('deleteRecording ERROR: $e');
        _log('deleteRecording STACK: $st');
      }
    }
    unawaited(_playSound(AppStrings.recordingDeleteSound));
    _recordPath = null;
    _isActionInFlight = false;
    _log('deleteRecording: end');
  }

  @override
  void dispose() {
    _log('dispose: begin');
    _progressSub?.cancel();
    _recorder.closeRecorder();
    _waveformController.dispose();
    _duration = Duration.zero;
    _log('dispose: end');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (_isRecording)
            CustomIconButton(
              bgColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              onPressed: _deleteRecording,
              icon: Icons.delete,
              iconColor: Theme.of(context).colorScheme.error,
            ),
          if (_isRecording)
            Expanded(
              child: AudioWaveforms(
                size: const Size(double.infinity, 40),
                recorderController: _waveformController,
                waveStyle: WaveStyle(
                  waveThickness: 2,
                  scaleFactor: 50,
                  waveColor: Theme.of(context).primaryColor,
                  extendWaveform: true,
                  showMiddleLine: false,
                ),
              ),
            ),
          _RecordingMicWidget(
            isRecording: _isRecording,
            duration: _duration,
            onStartRecording: _startRecording,
            onSendRecording: _sendRecording,
          ),
        ],
      ),
    );
  }
}

class _RecordingMicWidget extends StatelessWidget {
  const _RecordingMicWidget({
    required this.isRecording,
    required this.duration,
    required this.onStartRecording,
    required this.onSendRecording,
  });
  final bool isRecording;
  final Duration duration;
  final VoidCallback onStartRecording;
  final VoidCallback onSendRecording;

  @override
  Widget build(BuildContext context) {
    if (!isRecording) {
      return CustomIconButton(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        bgColor: Colors.transparent,
        onPressed: onStartRecording,
        icon: AppStrings.selloutChatMicIcon,
        iconColor: Theme.of(context).colorScheme.onSurface,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
      ),
      child: Row(
        children: <Widget>[
          Text(
            DurationFormatHelper.format(duration),
            style: TextStyle(
              color: ColorScheme.of(context).onSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          _PulsatingMic(
            isRecording: isRecording,
            color: Theme.of(context).colorScheme.secondary,
            onPressed: onSendRecording,
          ),
        ],
      ),
    );
  }
}

class _PulsatingMic extends StatefulWidget {
  const _PulsatingMic({
    required this.isRecording,
    required this.onPressed,
    required this.color,
  });
  final bool isRecording;
  final VoidCallback onPressed;
  final Color color;

  @override
  State<_PulsatingMic> createState() => _PulsatingMicState();
}

class _PulsatingMicState extends State<_PulsatingMic>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.0, end: 1.3),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.3, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isRecording) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant _PulsatingMic oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording) {
      _controller.repeat();
    } else {
      _controller.stop();
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(scale: _animation.value, child: child);
      },
      child: CustomIconButton(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        bgColor: Colors.transparent,
        onPressed: widget.onPressed,
        icon: AppStrings.selloutChatMicIcon,
        iconColor: widget.color,
      ),
    );
  }
}
