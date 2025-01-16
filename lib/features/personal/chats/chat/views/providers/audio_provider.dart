import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../core/functions/permission_fun.dart';
import '../../../../../../core/widgets/app_snakebar.dart';

class AudioProvider extends ChangeNotifier {
  final RecorderController _recoder = RecorderController();
  final PlayerController _player = PlayerController();

  RecorderController get recoder => _recoder;
  PlayerController get player => _player;

  Future<dynamic> get duration async =>
      await _player.getDuration(DurationType.max);

  Future<void> startPlayer(String url) async {
    _player.preparePlayer(
      path: url,
    );
    await _player.startPlayer();
    notifyListeners();
  }

  Future<void> stopPlayer() async {
    await _player.stopPlayer();
    notifyListeners();
  }

  Future<void> pausePlayer() async {
    await _player.pausePlayer();
    notifyListeners();
  }

  Future<void> setRate(double rate) async {
    await _player.setRate(rate);
    notifyListeners();
  }

  Future<void> seekTo(int value) async {
    await _player.seekTo(value);
    notifyListeners();
  }

  //
  // Recorder
  //
  Stream<Duration> get durationRecorder => _recoder.onCurrentDuration;

  Future<void> startRecorder(BuildContext context) async {
    final bool hasPermission =
        await PermissionFun.hasPermission(Permission.microphone);
    if (!hasPermission) {
      AppSnackBar.showSnackBar(context, 'microphone_permission_issue'.tr());
      return;
    }
    _recoder.refresh();
    await _recoder.record();
    notifyListeners();
  }

  Future<void> stopRecorder() async {
    await _recoder.stop();
    notifyListeners();
  }

  Future<void> pauseRecorder() async {
    await _recoder.pause();
    notifyListeners();
  }

  Future<void> resumeRecorder() async {
    await _recoder.record();
    notifyListeners();
  }

  void deleteRecorder() async {
    _recoder.reset();
    notifyListeners();
  }
}
