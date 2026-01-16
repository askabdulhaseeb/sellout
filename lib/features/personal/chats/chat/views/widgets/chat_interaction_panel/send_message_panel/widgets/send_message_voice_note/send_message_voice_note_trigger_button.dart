import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../../../../../../../core/functions/app_log.dart';
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
  static const String tag = 'VoiceRecordTrigger';

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
    AppLog.info('initState: starting recorder init', name: tag);
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    if (_recorderReady) return;
    try {
      final PermissionStatus status = await Permission.microphone.request();
      AppLog.info('microphone permission: $status', name: tag);
      if (!status.isGranted) {
        AppLog.info('microphone permission not granted; recorder not ready', name: tag);
        return;
      }
      await _recorder.openRecorder();
      await _recorder.setSubscriptionDuration(
        const Duration(milliseconds: 100),
      );
      _recorderReady = true;
      AppLog.info('recorder initialized successfully', name: tag);
    } catch (e, st) {
      AppLog.error(
        'initializeRecorder ERROR',
        name: tag,
        error: e,
        stackTrace: st,
      );
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
      AppLog.info('playSound: $assetPath', name: tag);
      await player.setAsset(assetPath); // Load asset
      await player.play();
      await player.processingStateStream.firstWhere(
        (ProcessingState s) => s == ProcessingState.completed,
      );
    } catch (e) {
      AppLog.info('playSound ERROR ($assetPath): $e', name: tag);
    } finally {
      player.dispose(); // Dispose after playing
    }
  }

  Future<void> _startRecording() async {
    if (_isActionInFlight) return;
    _isActionInFlight = true;

    AppLog.info(
      'startRecording: begin (ready=$_recorderReady, isRecording=$_isRecording, recorder.isRecording=${_recorder.isRecording})',
      name: tag,
    );

    final bool ready = await _ensureRecorderReady();
    if (!ready) {
      AppLog.info('startRecording: recorder not ready; abort', name: tag);
      _isActionInFlight = false;
      return;
    }

    try {
      final Directory dir = await getApplicationDocumentsDirectory();
      _recordPath =
          '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';
      AppLog.info('startRecording: path=$_recordPath', name: tag);
      await _recorder.startRecorder(toFile: _recordPath, codec: Codec.aacADTS);
      AppLog.info('startRecording: recorder started', name: tag);
    } catch (e, st) {
      AppLog.error(
        'startRecording ERROR',
        name: tag,
        error: e,
        stackTrace: st,
      );
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
    AppLog.info(
      'startRecording: progress listener attached=${_progressSub != null}',
      name: tag,
    );

    if (mounted) {
      setState(() {
        _isRecording = true;
      });
    }

    _isActionInFlight = false;
    AppLog.info('startRecording: done', name: tag);
  }

  Future<void> _stopRecording() async {
    AppLog.info(
      'stopRecording: begin (isRecording=$_isRecording, recorder.isRecording=${_recorder.isRecording}, path=$_recordPath)',
      name: tag,
    );
    try {
      await _progressSub?.cancel();
    } catch (e, st) {
      AppLog.info('stopRecording: cancel progress ERROR: $e', name: tag);
      AppLog.info('stopRecording: cancel progress STACK: $st', name: tag);
    }
    _progressSub = null;

    try {
      if (_recorder.isRecording) {
        AppLog.info('stopRecording: calling stopRecorder()', name: tag);
        final String? stoppedPath = await _recorder
            .stopRecorder()
            .timeout(const Duration(seconds: 4));
        AppLog.info('stopRecording: stopRecorder returned=$stoppedPath', name: tag);
        if (stoppedPath != null && stoppedPath.isNotEmpty) {
          _recordPath = stoppedPath;
        }
      } else {
        AppLog.info('stopRecording: recorder was not recording', name: tag);
      }
    } on TimeoutException catch (e, st) {
      AppLog.info('stopRecording: stopRecorder TIMEOUT: $e', name: tag);
      AppLog.info('stopRecording: stopRecorder TIMEOUT STACK: $st', name: tag);
    } catch (e, st) {
      AppLog.error(
        'stopRecording ERROR',
        name: tag,
        error: e,
        stackTrace: st,
      );
    }

    try {
      AppLog.info('stopRecording: stopping waveform controller', name: tag);
      await _waveformController
          .stop()
          .timeout(const Duration(seconds: 2));
      AppLog.info('stopRecording: waveform controller stopped', name: tag);
    } on TimeoutException catch (e, st) {
      AppLog.info('stopRecording: waveform stop TIMEOUT: $e', name: tag);
      AppLog.info('stopRecording: waveform stop TIMEOUT STACK: $st', name: tag);
    } catch (e, st) {
      AppLog.info('stopRecording: waveform stop ERROR: $e', name: tag);
      AppLog.info('stopRecording: waveform stop STACK: $st', name: tag);
    }

    _msgPro.stopRecording();
    AppLog.info('stopRecording: provider stopRecording called', name: tag);

    if (mounted) {
      setState(() {
        _isRecording = false;
        _duration = Duration.zero;
      });
    }
    AppLog.info('stopRecording: end (path=$_recordPath)', name: tag);
  }

  Future<void> _sendRecording() async {
    if (_isActionInFlight) return;
    _isActionInFlight = true;
    AppLog.info('sendRecording: begin', name: tag);
    await _stopRecording();
    if (_recordPath != null) {
      final File file = File(_recordPath!);
      try {
        final bool exists = await file.exists();
        AppLog.info('sendRecording: file exists=$exists path=$_recordPath', name: tag);
        if (exists) {
          final int length = await file.length();
          AppLog.info('sendRecording: file length=$length bytes', name: tag);
          if (length == 0) {
            AppLog.info('sendRecording: file length is 0; abort', name: tag);
            _isActionInFlight = false;
            return;
          }
          _msgPro.addVoiceNote(
            PickedAttachment(file: file, type: AttachmentType.audio),
          );
          AppLog.info('sendRecording: provider addVoiceNote called', name: tag);
          unawaited(_playSound(AppStrings.recordingShareSound));
          await _msgPro.sendVoiceNote(context);
          AppLog.info('sendRecording: provider sendVoiceNote finished', name: tag);
        }
      } catch (e, st) {
        AppLog.error(
          'sendRecording ERROR',
          name: tag,
          error: e,
          stackTrace: st,
        );
      }
    }
    _recordPath = null;
    _isActionInFlight = false;
    AppLog.info('sendRecording: end', name: tag);
  }

  Future<void> _deleteRecording() async {
    if (_isActionInFlight) return;
    _isActionInFlight = true;

    AppLog.info('deleteRecording: begin (path=$_recordPath)', name: tag);

    await _stopRecording();
    if (_recordPath != null) {
      final File file = File(_recordPath!);
      try {
        final bool exists = await file.exists();
        AppLog.info('deleteRecording: file exists=$exists path=$_recordPath', name: tag);
        if (exists) {
          // Give the OS a moment to release the handle.
          await Future<void>.delayed(const Duration(milliseconds: 80));
          await file.delete();
          AppLog.info('deleteRecording: file deleted', name: tag);
        }
      } catch (e, st) {
        AppLog.error(
          'deleteRecording ERROR',
          name: tag,
          error: e,
          stackTrace: st,
        );
      }
    }
    unawaited(_playSound(AppStrings.recordingDeleteSound));
    _recordPath = null;
    _isActionInFlight = false;
    AppLog.info('deleteRecording: end', name: tag);
  }

  @override
  void dispose() {
    AppLog.info('dispose: begin', name: tag);
    _progressSub?.cancel();
    _recorder.closeRecorder();
    _waveformController.dispose();
    _duration = Duration.zero;
    AppLog.info('dispose: end', name: tag);
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

    _animation = TweenSequence<double>(<TweenSequenceItem<double>>[
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
