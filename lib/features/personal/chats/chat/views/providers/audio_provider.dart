import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

class AudioProvider extends ChangeNotifier {
  final RecorderController _recorderController = RecorderController();
  final PlayerController _playerController = PlayerController();
 RecorderController get recorderController => _recorderController;
  String? _currentlyPlayingPath;

  RecorderController get recorder => _recorderController;

  bool get isRecording => _recorderController.isRecording;

  bool isPlaying(String filePath) {
    return _currentlyPlayingPath == filePath &&
        _playerController.playerState == PlayerState.playing;
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
      await _playerController.preparePlayer(path: filePath);
      await _playerController.startPlayer();

      _playerController.onPlayerStateChanged.listen((PlayerState state) {
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
      await _playerController.pausePlayer();
      _currentlyPlayingPath = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _recorderController.dispose();
    _playerController.dispose();
    super.dispose();
  }
}
