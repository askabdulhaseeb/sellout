import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioProvider extends ChangeNotifier {
  final RecorderController _recorderController = RecorderController();
  final Map<String, PlayerController> _playerControllers =
      <String, PlayerController>{};
  final Map<String, Duration> _audioDurations = <String, Duration>{};
  String? _currentRecordingPath;
  String? _currentlyPlayingPath;

  RecorderController get recorder => _recorderController;
  bool get isRecording => _recorderController.isRecording;
  String? get currentlyPlayingPath => _currentlyPlayingPath;

  Future<void> startRecording(BuildContext context) async {
    try {
      final bool hasPermission = await _checkMicrophonePermission(context);
      if (!hasPermission) return;

      _currentRecordingPath = await _getRecordingPath();
      await _recorderController.record(path: _currentRecordingPath);
      notifyListeners();
    } catch (e) {
      _showErrorSnackbar(context, 'failed_to_start_recording'.tr());
    }
  }

  Future<String?> stopRecording() async {
    try {
      final String? path = await _recorderController.stop();
      _currentRecordingPath = null;
      notifyListeners();
      return path;
    } catch (e) {
      return null;
    }
  }

  Future<void> togglePlaying(String filePath) async {
    if (_currentlyPlayingPath == filePath) {
      await pauseCurrent();
    } else {
      await _playFile(filePath);
    }
  }

  Future<void> _playFile(String filePath) async {
    try {
      await pauseCurrent();
      _currentlyPlayingPath = filePath;

      final PlayerController player =
          _playerControllers[filePath] ?? PlayerController();
      await player.preparePlayer(path: filePath);
      await player.startPlayer();

      if (!_playerControllers.containsKey(filePath)) {
        _playerControllers[filePath] = player;
      }

      player.onPlayerStateChanged.listen((PlayerState state) {
        if (state == PlayerState.stopped) {
          _currentlyPlayingPath = null;
          notifyListeners();
        }
      });

      notifyListeners();
    } catch (e) {
      _currentlyPlayingPath = null;
      notifyListeners();
    }
  }

  Future<void> pauseCurrent() async {
    if (_currentlyPlayingPath != null) {
      await _playerControllers[_currentlyPlayingPath]?.pausePlayer();
      _currentlyPlayingPath = null;
      notifyListeners();
    }
  }

  Duration? getDuration(String filePath) {
    return _audioDurations[filePath];
  }

  bool isPlaying(String filePath) {
    return _currentlyPlayingPath == filePath &&
        _playerControllers[filePath]?.playerState == PlayerState.playing;
  }

  Future<void> loadDurations(List<String> audioPaths) async {
    for (final String path in audioPaths) {
      if (!_audioDurations.containsKey(path)) {
        final PlayerController player = PlayerController();
        await player.preparePlayer(path: path);
        _audioDurations[path] = (await player.getDuration()) as Duration;
        await player.stopPlayer();
        player.dispose();
      }
    }
    notifyListeners();
  }

  Future<bool> _checkMicrophonePermission(BuildContext context) async {
    final PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      _showErrorSnackbar(context, 'microphone_permission_issue'.tr());
      return false;
    }
    return true;
  }

  Future<String> _getRecordingPath() async {
    final Directory dir = Directory.systemTemp;
    return '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _recorderController.dispose();
    for (final PlayerController player in _playerControllers.values) {
      player.dispose();
    }
    super.dispose();
  }
}
