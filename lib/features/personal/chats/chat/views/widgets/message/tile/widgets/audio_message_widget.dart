import 'dart:async';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/helper_functions/duration_format_helper.dart';
import '../../../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../../../core/widgets/custom_icon_button.dart';
import '../../../../../../../../../core/widgets/custom_svg_icon.dart';
import '../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../../providers/send_message_provider.dart';

enum AudioState { loading, ready, playing, paused, error }

class AudioMessageWidget extends StatefulWidget {
  const AudioMessageWidget({required this.message, super.key});
  final MessageEntity message;

  @override
  State<AudioMessageWidget> createState() => _AudioMessageWidgetState();
}

class _AudioMessageWidgetState extends State<AudioMessageWidget>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  late final PlayerController _playerController;
  late final AnimationController _playbackSpeedController;

  AudioState _audioState = AudioState.loading;
  String? _cachedFilePath;
  double _downloadProgress = 0.0;
  double _playbackSpeed = 1.0;

  Duration _currentPos = Duration.zero;
  Duration _totalDur = Duration.zero;

  StreamSubscription<int>? _posSub;
  StreamSubscription<void>? _completeSub;

  // Static references to manage only one active player at a time
  static PlayerController? _currentlyPlayingController;
  static void Function(PlayerController?)? onGlobalPlayChanged;

  static const List<double> _speedOptions = <double>[1.0, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    _playerController = PlayerController();
    _playbackSpeedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _subscribeToPlayerEvents();
    _prepareAudio();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final SendMessageProvider messageProvider = context
        .watch<SendMessageProvider>();
    if (messageProvider.isRecordingAudio.value) {
      if (_audioState == AudioState.playing) {
        _pausePlayer();
      }
    }
  }

  void _subscribeToPlayerEvents() {
    _posSub = _playerController.onCurrentDurationChanged.listen((int ms) {
      if (!mounted) return;
      setState(() => _currentPos = Duration(milliseconds: ms));
    });

    _completeSub = _playerController.onCompletion.listen((_) async {
      if (!mounted) return;
      setState(() {
        _currentPos = Duration.zero;
        _audioState = AudioState.ready;
      });
      // Re-prepare player after completion so it can play again
      if (_cachedFilePath != null) {
        await _refreshPlayer();
      }
    });

    onGlobalPlayChanged = (PlayerController? activeController) {
      if (!mounted) return;
      if (activeController != _playerController &&
          _audioState == AudioState.playing) {
        _pausePlayer();
      }
    };
  }

  /// Re-prepare player without showing loading state
  Future<void> _refreshPlayer() async {
    if (_cachedFilePath == null) return;
    try {
      await _playerController.preparePlayer(
        noOfSamples: 50,
        path: _cachedFilePath!,
        shouldExtractWaveform: false,
      );
    } catch (e) {
      debugPrint('Error refreshing player: $e');
    }
  }

  Future<void> _prepareAudio() async {
    if (!mounted) return;
    setState(() {
      _audioState = AudioState.loading;
      _downloadProgress = 0.0;
    });

    try {
      final String url = widget.message.fileUrl[0].url;
      _cachedFilePath ??= await _downloadOrGetFile(url);
      await _setupPlayer(_cachedFilePath!);
    } catch (e) {
      debugPrint('Error preparing audio: $e');
      if (!mounted) return;
      setState(() => _audioState = AudioState.error);
    }
  }

  Future<String> _downloadOrGetFile(String url) async {
    if (!url.startsWith('http')) return url;

    final Directory tempDir = await getTemporaryDirectory();
    final String filePath = '${tempDir.path}/${url.split('/').last}';
    final File file = File(filePath);

    if (!file.existsSync()) {
      final http.Client client = http.Client();
      try {
        final http.Request request = http.Request('GET', Uri.parse(url));
        final http.StreamedResponse response = await client.send(request);

        final int totalBytes = response.contentLength ?? 0;
        int receivedBytes = 0;
        final List<int> bytes = <int>[];

        await for (final List<int> chunk in response.stream) {
          bytes.addAll(chunk);
          receivedBytes += chunk.length;
          if (totalBytes > 0 && mounted) {
            setState(() {
              _downloadProgress = receivedBytes / totalBytes;
            });
          }
        }

        await file.writeAsBytes(bytes);
      } finally {
        client.close();
      }
    } else {
      if (mounted) {
        setState(() => _downloadProgress = 1.0);
      }
    }

    return filePath;
  }

  Future<void> _setupPlayer(String path) async {
    await _playerController.preparePlayer(
      noOfSamples: 50,
      path: path,
      shouldExtractWaveform: true,
    );

    final int totalMs = await _playerController.getDuration(DurationType.max);
    if (!mounted) return;
    setState(() {
      _totalDur = Duration(milliseconds: totalMs);
      _audioState = AudioState.ready;
    });
  }

  Future<void> _pausePlayer() async {
    await _playerController.pausePlayer();
    if (_currentlyPlayingController == _playerController) {
      _currentlyPlayingController = null;
    }
    if (mounted) {
      setState(() => _audioState = AudioState.paused);
    }
  }

  Future<void> _playPause() async {
    final SendMessageProvider messageProvider =
        context.read<SendMessageProvider>();

    if (messageProvider.isRecordingAudio.value) return;

    // Handle error state - retry
    if (_audioState == AudioState.error) {
      _cachedFilePath = null;
      _prepareAudio();
      return;
    }

    // Don't allow interaction while loading
    if (_audioState == AudioState.loading) return;

    if (_audioState == AudioState.playing) {
      await _pausePlayer();
      return;
    }

    // Pause other active players
    onGlobalPlayChanged?.call(null);
    if (_currentlyPlayingController != null &&
        _currentlyPlayingController != _playerController) {
      await _currentlyPlayingController!.pausePlayer();
    }

    _currentlyPlayingController = _playerController;
    onGlobalPlayChanged?.call(_playerController);

    await _playerController.startPlayer(forceRefresh: true);
    if (mounted) {
      setState(() => _audioState = AudioState.playing);
    }
  }

  Future<void> _seekTo(double progress) async {
    if (_audioState == AudioState.loading || _audioState == AudioState.error) {
      return;
    }

    final int seekMs = (progress * _totalDur.inMilliseconds).toInt();
    await _playerController.seekTo(seekMs);
    setState(() => _currentPos = Duration(milliseconds: seekMs));
  }

  void _cyclePlaybackSpeed() {
    final int currentIndex = _speedOptions.indexOf(_playbackSpeed);
    final int nextIndex = (currentIndex + 1) % _speedOptions.length;
    setState(() {
      _playbackSpeed = _speedOptions[nextIndex];
    });
    _playerController.setRate(_playbackSpeed);
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _completeSub?.cancel();
    _playbackSpeedController.dispose();
    _playerController.dispose();
    if (_currentlyPlayingController == _playerController) {
      _currentlyPlayingController = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bool isMe = widget.message.sendBy == LocalAuth.uid;
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: _buildContent(isMe, theme, colorScheme),
      ),
    );
  }

  Widget _buildContent(bool isMe, ThemeData theme, ColorScheme colorScheme) {
    switch (_audioState) {
      case AudioState.loading:
        return _buildLoadingUI(colorScheme, theme);
      case AudioState.error:
        return _buildErrorUI(colorScheme, theme);
      case AudioState.ready:
      case AudioState.playing:
      case AudioState.paused:
        return _buildPlayerUI(isMe, colorScheme, theme);
    }
  }

  Widget _buildLoadingUI(ColorScheme colorScheme, ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    value: _downloadProgress > 0 ? _downloadProgress : null,
                    strokeWidth: 2.5,
                    color: theme.primaryColor,
                    backgroundColor: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                  Icon(Icons.mic_rounded, color: colorScheme.outline, size: 18),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: colorScheme.outline.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _downloadProgress > 0
                        ? '${(_downloadProgress * 100).toInt()}%'
                        : 'Loading...',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.outline,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorUI(ColorScheme colorScheme, ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            CustomIconButton(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              onPressed: _playPause,
              icon: Icons.refresh_rounded,
              iconColor: colorScheme.error,
              bgColor: colorScheme.error.withValues(alpha: 0.1),
              iconSize: 40,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: colorScheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.error_outline_rounded,
                        size: 12,
                        color: colorScheme.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Failed to load. Tap to retry',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.error,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlayerUI(bool isMe, ColorScheme colorScheme, ThemeData theme) {
    final bool isPlaying = _audioState == AudioState.playing;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            // Play/Pause button
            CustomIconButton(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              onPressed: _playPause,
              icon: isPlaying
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_filled,
              iconColor: theme.primaryColor,
              bgColor: Colors.transparent,
              iconSize: 42,
            ),
            const SizedBox(width: 4),
            // Waveform with seek gesture
            Expanded(
              child: GestureDetector(
                onTapDown: (TapDownDetails details) {
                  final RenderBox box =
                      context.findRenderObject()! as RenderBox;
                  final double localX = details.localPosition.dx;
                  // Account for play button width (46) and spacing (4)
                  final double waveformWidth = box.size.width - 46 - 4 - 24;
                  final double progress = (localX / waveformWidth).clamp(
                    0.0,
                    1.0,
                  );
                  _seekTo(progress);
                },
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  final RenderBox box =
                      context.findRenderObject()! as RenderBox;
                  final double localX = details.localPosition.dx;
                  final double waveformWidth = box.size.width - 46 - 4 - 24;
                  final double progress = (localX / waveformWidth).clamp(
                    0.0,
                    1.0,
                  );
                  _seekTo(progress);
                },
                child: AudioFileWaveforms(
                  enableSeekGesture: true,
                  continuousWaveform: true,
                  waveformType: WaveformType.fitWidth,
                  size: const Size(double.infinity, 36),
                  playerController: _playerController,
                  playerWaveStyle: PlayerWaveStyle(
                    scaleFactor: 80,
                    fixedWaveColor: colorScheme.outline.withValues(alpha: 0.4),
                    liveWaveColor: theme.primaryColor,
                    showSeekLine: false,
                    seekLineColor: Colors.transparent,
                    spacing: 4,
                    waveThickness: 3,
                    waveCap: StrokeCap.round,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            // Speaker icon or speed indicator
            GestureDetector(
              onTap: isPlaying ? _cyclePlaybackSpeed : null,
              child: isPlaying && _playbackSpeed != 1.0
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${_playbackSpeed}x',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    )
                  : CustomSvgIcon(
                      color: isPlaying
                          ? theme.primaryColor
                          : colorScheme.outline,
                      assetPath: AppStrings.selloutVoiceNoteSpeakerIcon,
                      size: 20,
                    ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        // Time row
        Row(
          children: <Widget>[
            const SizedBox(width: 46),
            Text(
              isPlaying || _currentPos.inMilliseconds > 0
                  ? DurationFormatHelper.format(_currentPos)
                  : DurationFormatHelper.format(_totalDur),
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.outline,
                fontSize: 11,
                fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
              ),
            ),
            if (isPlaying || _currentPos.inMilliseconds > 0) ...<Widget>[
              Text(
                ' / ',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.outline.withValues(alpha: 0.5),
                  fontSize: 11,
                ),
              ),
              Text(
                DurationFormatHelper.format(_totalDur),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.outline.withValues(alpha: 0.5),
                  fontSize: 11,
                  fontFeatures: const <FontFeature>[
                    FontFeature.tabularFigures(),
                  ],
                ),
              ),
            ],
            const Spacer(),
            // Playback speed button (visible when playing)
            if (isPlaying)
              GestureDetector(
                onTap: _cyclePlaybackSpeed,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${_playbackSpeed}x',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.outline,
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
