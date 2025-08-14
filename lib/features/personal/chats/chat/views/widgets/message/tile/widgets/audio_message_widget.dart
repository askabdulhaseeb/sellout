import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../../../../../../../../core/helper_functions/duration_format_helper.dart';
import '../../../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';

class AudioMessageWidget extends StatefulWidget {
  const AudioMessageWidget({required this.message, super.key});
  final MessageEntity message;

  @override
  State<AudioMessageWidget> createState() => _AudioMessageWidgetState();
}

class _AudioMessageWidgetState extends State<AudioMessageWidget> {
  late PlayerController _playerController;
  bool _isLoading = true;

  static PlayerController? _currentlyPlayingController;
  static void Function(PlayerController?)? onGlobalPlayChanged;

  Duration _currentPos = Duration.zero;
  Duration _totalDur = Duration.zero;

  StreamSubscription<int>? _posSub;
  StreamSubscription<void>? _completeSub;

  @override
  void initState() {
    super.initState();
    _playerController = PlayerController();
    _posSub = _playerController.onCurrentDurationChanged.listen((int ms) {
      if (!mounted) return;
      setState(() => _currentPos = Duration(milliseconds: ms));
    });

    _completeSub = _playerController.onCompletion.listen((_) async {
      await _playerController.stopPlayer();
      if (!mounted) return;
      setState(() {
        _currentPos = Duration.zero;
      });
    });

    // When another player starts, pause this one and update UI
    _AudioMessageWidgetState.onGlobalPlayChanged = (PlayerController? active) {
      if (!mounted) return;
      if (active != _playerController) {
        _playerController.pauseAllPlayers();
      }
    };

    _prepareAudio();
  }

  Future<void> _prepareAudio() async {
    final String url = widget.message.fileUrl[0].url;
    if (!mounted) return;
    setState(() => _isLoading = true);

    String filePath;
    if (url.startsWith('http')) {
      final Directory dir = await getTemporaryDirectory();
      filePath = '${dir.path}/${url.split('/').last}';
      if (!File(filePath).existsSync()) {
        final http.Response response = await http.get(Uri.parse(url));
        await File(filePath).writeAsBytes(response.bodyBytes);
      }
    } else {
      filePath = url;
    }

    await _playerController.preparePlayer(
      noOfSamples: 30,
      path: filePath,
      shouldExtractWaveform: true,
    );

    final int totalMs = await _playerController.getDuration(DurationType.max);
    if (!mounted) return;
    setState(() {
      _totalDur = Duration(milliseconds: totalMs);
      _isLoading = false;
    });
  }

  Future<void> _playPause() async {
    if (_playerController.playerState.isPlaying) {
      await _playerController.pausePlayer();
      if (!mounted) return;
    } else {
      final int currentMs =
          await _playerController.getDuration(DurationType.current);
      final int totalMs = await _playerController.getDuration(DurationType.max);

      if (currentMs >= totalMs) {
        await _playerController.stopPlayer();
        _currentPos = Duration.zero;
        await _prepareAudio();
      }

      // Pause ALL other players first
      if (onGlobalPlayChanged != null) {
        onGlobalPlayChanged!(null);
      }

      // Stop previous controller if different
      if (_currentlyPlayingController != null &&
          _currentlyPlayingController != _playerController) {
        await _currentlyPlayingController!.pausePlayer();
        setState(() {});
      }

      _currentlyPlayingController = _playerController;
      // Notify that THIS controller is active
      if (onGlobalPlayChanged != null) {
        onGlobalPlayChanged!(_playerController);
      }

      await _playerController.startPlayer(forceRefresh: true);
      if (!mounted) return;
    }
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _completeSub?.cancel();
    _playerController.dispose();
    if (_currentlyPlayingController == _playerController) {
      _currentlyPlayingController = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMe = widget.message.sendBy == LocalAuth.uid;
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
            : Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: _playPause,
                        icon: Icon(
                          _playerController.playerState.isPlaying
                              ? Icons.pause_circle
                              : Icons.play_circle_fill_outlined,
                          color: !isMe
                              ? AppTheme.primaryColor
                              : colorScheme.secondary,
                          size: 30,
                        ),
                      ),
                      Expanded(
                        child: AudioFileWaveforms(
                          enableSeekGesture: false,
                          continuousWaveform: false,
                          waveformType: WaveformType.fitWidth,
                          size: const Size(150, 40),
                          playerController: _playerController,
                          playerWaveStyle: PlayerWaveStyle(
                            fixedWaveColor: colorScheme.outline,
                            liveWaveColor: (!isMe
                                ? AppTheme.primaryColor
                                : colorScheme.secondary),
                            showSeekLine: false,
                            seekLineColor: Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '${DurationFormatHelper.format(_currentPos)} / ${DurationFormatHelper.format(_totalDur)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            !isMe ? colorScheme.outline : colorScheme.outline,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
