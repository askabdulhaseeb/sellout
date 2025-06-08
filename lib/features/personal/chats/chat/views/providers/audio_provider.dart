import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  String? _currentlyPlayingPath;
  bool _isPlaying = false;

  AudioProvider() {
    _player.onPlayerComplete.listen((event) {
      _currentlyPlayingPath = null;
      _isPlaying = false;
      notifyListeners();
    });
    _player.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });
  }

  bool isPlaying(String filePath) {
    return _currentlyPlayingPath == filePath && _isPlaying;
  }

  Future<void> togglePlaying(String filePath) async {
    if (_currentlyPlayingPath == filePath && _isPlaying) {
      await _player.pause();
      _isPlaying = false;
      notifyListeners();
      return;
    }

    // If playing something else, stop first
    if (_isPlaying || _currentlyPlayingPath != filePath) {
      await _player.stop();
    }

    _currentlyPlayingPath = filePath;

    try {
      await _player.play(DeviceFileSource(filePath));
    } catch (e) {
      debugPrint('Playback error: $e');
      _currentlyPlayingPath = null;
      _isPlaying = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
