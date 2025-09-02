import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/helper_functions/duration_format_helper.dart';
import '../../../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../../../core/widgets/custom_icon_button.dart';
import '../../../../../../../../../core/widgets/custom_svg_icon.dart';
import '../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../../providers/send_message_provider.dart';

class AudioMessageWidget extends StatefulWidget {
  const AudioMessageWidget({required this.message, super.key});
  final MessageEntity message;

  @override
  State<AudioMessageWidget> createState() => _AudioMessageWidgetState();
}

class _AudioMessageWidgetState extends State<AudioMessageWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Keep widget alive in ListView

  late final PlayerController _playerController;
  bool _isLoading = true;
  String? _cachedFilePath;

  Duration _currentPos = Duration.zero;
  Duration _totalDur = Duration.zero;

  StreamSubscription<int>? _posSub;
  StreamSubscription<void>? _completeSub;

  // Static references to manage only one active player at a time
  static PlayerController? _currentlyPlayingController;
  static void Function(PlayerController?)? onGlobalPlayChanged;

  @override
  void initState() {
    super.initState();
    _playerController = PlayerController();
    _subscribeToPlayerEvents();
    _prepareAudio();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final SendMessageProvider messageProvider =
        context.watch<SendMessageProvider>();
    if (messageProvider.isRecordingAudio.value) {
      if (_playerController.playerState.isPlaying) {
        _playerController.pauseAllPlayers();
        if (_currentlyPlayingController == _playerController) {
          _currentlyPlayingController = null;
        }
        setState(() {});
      }
    }
  }

  void _subscribeToPlayerEvents() {
    _posSub = _playerController.onCurrentDurationChanged.listen((int ms) {
      if (!mounted) return;
      setState(() => _currentPos = Duration(milliseconds: ms));
    });

    _completeSub = _playerController.onCompletion.listen((_) async {
      await _playerController.stopPlayer();
      if (!mounted) return;
      setState(() => _currentPos = Duration.zero);
    });

    onGlobalPlayChanged = (PlayerController? activeController) {
      if (!mounted) return;
      if (activeController != _playerController) {
        _playerController.pauseAllPlayers();
      }
    };
  }

  Future<void> _prepareAudio() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final String url = widget.message.fileUrl[0].url;
      _cachedFilePath ??= await _downloadOrGetFile(url);
      await _setupPlayer(_cachedFilePath!);
    } catch (e) {
      debugPrint('Error preparing audio: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<String> _downloadOrGetFile(String url) async {
    if (!url.startsWith('http')) return url;

    final Directory tempDir = await getTemporaryDirectory();
    final String filePath = '${tempDir.path}/${url.split('/').last}';
    final File file = File(filePath);

    if (!file.existsSync()) {
      final http.Response response = await http.get(Uri.parse(url));
      await file.writeAsBytes(response.bodyBytes);
    }

    return filePath;
  }

  Future<void> _setupPlayer(String path) async {
    await _playerController.preparePlayer(
      noOfSamples: 30,
      path: path,
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
    final SendMessageProvider messageProvider =
        context.read<SendMessageProvider>();

    if (messageProvider.isRecordingAudio.value) return;

    if (_playerController.playerState.isPlaying) {
      await _playerController.pauseAllPlayers();
      return;
    }

    // Replay if finished
    final int currentMs =
        await _playerController.getDuration(DurationType.current);
    final int totalMs = await _playerController.getDuration(DurationType.max);

    if (currentMs >= totalMs) {
      await _playerController.stopPlayer();
      _currentPos = Duration.zero;
      if (_cachedFilePath != null) {
        await _setupPlayer(_cachedFilePath!);
      }
    }

    // Pause other active players
    onGlobalPlayChanged?.call(null);
    if (_currentlyPlayingController != null &&
        _currentlyPlayingController != _playerController) {
      await _currentlyPlayingController!.pausePlayer();
      setState(() {});
    }

    _currentlyPlayingController = _playerController;
    onGlobalPlayChanged?.call(_playerController);

    await _playerController.startPlayer(forceRefresh: true);
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
    super.build(context); // Required for keep-alive
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
            ? _buildLoadingUI(isMe, colorScheme)
            : _buildPlayerUI(isMe, colorScheme),
      ),
    );
  }

  Widget _buildLoadingUI(bool isMe, ColorScheme colorScheme) => Column(
        children: [
          Row(
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.play_circle_fill_outlined,
                  color: AppTheme.primaryColor,
                  size: 30,
                ),
              ),
              Expanded(
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              '00:00',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
            ),
          ),
        ],
      );

  Widget _buildPlayerUI(bool isMe, ColorScheme colorScheme) => Column(
        children: <Widget>[
          Row(
            spacing: 2,
            children: <Widget>[
              CustomIconButton(
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.all(0),
                onPressed: _playPause,
                icon: _playerController.playerState.isPlaying
                    ? Icons.pause_circle
                    : Icons.play_circle_fill_outlined,
                iconColor: AppTheme.primaryColor,
                bgColor: Colors.transparent,
                iconSize: 40,
              ),
              Expanded(
                child: AudioFileWaveforms(
                  enableSeekGesture: false,
                  continuousWaveform: false,
                  waveformType: WaveformType.fitWidth,
                  size: const Size(150, 40),
                  playerController: _playerController,
                  playerWaveStyle: PlayerWaveStyle(
                    scaleFactor: 5,
                    fixedWaveColor: colorScheme.outline,
                    liveWaveColor: AppTheme.primaryColor,
                    showSeekLine: false,
                    seekLineColor: Colors.transparent,
                  ),
                ),
              ),
              CustomSvgIcon(
                color: _playerController.playerState.isPlaying
                    ? Theme.of(context).primaryColor
                    : colorScheme.outline,
                assetPath: AppStrings.selloutVoiceNoteSpeakerIcon,
                size: 18,
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              _playerController.playerState.isPlaying
                  ? DurationFormatHelper.format(_currentPos)
                  : DurationFormatHelper.format(_totalDur),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
            ),
          ),
        ],
      );
}
