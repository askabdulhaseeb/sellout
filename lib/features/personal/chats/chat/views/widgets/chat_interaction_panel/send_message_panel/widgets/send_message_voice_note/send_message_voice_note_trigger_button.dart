import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../../../../../../../core/helper_functions/duration_format_helper.dart';
import '../../../../../../../../../../core/theme/app_theme.dart';
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
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  late final RecorderController _waveformController;
  late final SendMessageProvider _msgPro;

  bool _isRecording = false;
  String? _recordPath;
  Duration _duration = Duration.zero;
  bool _recorderInitialized = false;

  @override
  void initState() {
    super.initState();
    _msgPro = Provider.of<SendMessageProvider>(context, listen: false);
    _waveformController = RecorderController();
  }

  /// Ensures recorder is ready after permission is granted
  Future<void> _initializeRecorder() async {
    if (_recorderInitialized) return;
    await _recorder.openRecorder();
    await _recorder.setSubscriptionDuration(const Duration(milliseconds: 100));
    _recorderInitialized = true;
  }

  Future<void> _playSound(String assetPath) async {
    final AudioPlayer player = AudioPlayer();
    try {
      await player.setAsset(assetPath);
      await player.play();
    } catch (e) {
      debugPrint('Error playing sound $assetPath: $e');
    } finally {
      player.dispose();
    }
  }

  Future<void> _startRecording() async {
    // Check permission first
    PermissionStatus status = await Permission.microphone.status;

    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }

    if (status.isPermanentlyDenied) {
      openAppSettings();
      return;
    }

    if (!status.isGranted) {
      // Permission denied but not permanent → stop here
      return;
    }

    // Permission granted → initialize recorder if not already
    await _initializeRecorder();

    // Prepare file path
    final Directory dir = await getApplicationDocumentsDirectory();
    _recordPath =
        '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';

    // Start recording
    await _recorder.startRecorder(toFile: _recordPath, codec: Codec.aacADTS);
    _waveformController.record();
    _playSound(AppStrings.recordingStartSound);
    _msgPro.startRecording();

    // Track duration
    _recorder.onProgress?.listen((RecordingDisposition event) {
      setState(() {
        _duration = event.duration;
      });
    });

    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    if (_recorder.isRecording) await _recorder.stopRecorder();
    try {
      await _waveformController.stop();
    } catch (_) {}

    _msgPro.stopRecording();

    setState(() {
      _isRecording = false;
      _duration = Duration.zero;
    });
  }

  Future<void> _sendRecording() async {
    await _stopRecording();
    if (_recordPath != null) {
      final File file = File(_recordPath!);
      if (await file.exists()) {
        _msgPro.addVoiceNote(
          PickedAttachment(file: file, type: AttachmentType.audio),
        );
        _playSound(AppStrings.recordingShareSound);
        _msgPro.sendVoiceNote(context);
      }
    }
    _recordPath = null;
  }

  Future<void> _deleteRecording() async {
    await _stopRecording();
    if (_recordPath != null) {
      final File file = File(_recordPath!);
      if (await file.exists()) await file.delete();
    }
    _playSound(AppStrings.recordingDeleteSound);
    _recordPath = null;
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _waveformController.dispose();
    _duration = Duration.zero;
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
              bgColor: AppTheme.primaryColor.withValues(alpha: 0.1),
              onPressed: _deleteRecording,
              icon: Icons.delete,
              iconColor: Theme.of(context).colorScheme.error,
            ),
          if (_isRecording)
            Expanded(
              child: AudioWaveforms(
                size: const Size(double.infinity, 40),
                recorderController: _waveformController,
                waveStyle: const WaveStyle(
                  waveThickness: 2,
                  scaleFactor: 50,
                  waveColor: AppTheme.primaryColor,
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
        color: AppTheme.secondaryColor.withValues(alpha: 0.3),
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
            color: AppTheme.secondaryColor,
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

    _animation = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
            tween: Tween<double>(begin: 1.0, end: 1.3), weight: 10),
        TweenSequenceItem<double>(
            tween: Tween<double>(begin: 1.3, end: 1.0), weight: 10),
      ],
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

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
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
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
