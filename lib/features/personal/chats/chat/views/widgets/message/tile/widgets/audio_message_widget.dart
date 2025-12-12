import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/helper_functions/duration_format_helper.dart';
import '../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../../providers/send_message_provider.dart';

/// Audio player states for better state management
enum AudioPlayerState {
  initial,
  downloading,
  preparing,
  ready,
  playing,
  paused,
  completed,
  error,
}

class AudioMessageWidget extends StatefulWidget {
  const AudioMessageWidget({required this.message, super.key});
  final MessageEntity message;

  @override
  State<AudioMessageWidget> createState() => _AudioMessageWidgetState();
}

class _AudioMessageWidgetState extends State<AudioMessageWidget>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  late final PlayerController _playerController;
  late final AnimationController _playPauseController;
  late final AnimationController _loadingController;

  AudioPlayerState _audioState = AudioPlayerState.initial;
  String? _cachedFilePath;
  String? _errorMessage;
  double _downloadProgress = 0.0;

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
    _playPauseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _subscribeToPlayerEvents();
    _prepareAudio();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final SendMessageProvider messageProvider =
        context.watch<SendMessageProvider>();
    if (messageProvider.isRecordingAudio.value) {
      if (_audioState == AudioPlayerState.playing) {
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
      await _playerController.stopPlayer();
      if (!mounted) return;
      _playPauseController.reverse();
      setState(() {
        _currentPos = _totalDur;
        _audioState = AudioPlayerState.completed;
      });
    });

    onGlobalPlayChanged = (PlayerController? activeController) {
      if (!mounted) return;
      if (activeController != _playerController &&
          _audioState == AudioPlayerState.playing) {
        _pausePlayer();
      }
    };
  }

  Future<void> _prepareAudio() async {
    if (!mounted) return;
    setState(() => _audioState = AudioPlayerState.downloading);

    try {
      final String url = widget.message.fileUrl[0].url;
      _cachedFilePath ??= await _downloadOrGetFile(url);

      if (!mounted) return;
      setState(() => _audioState = AudioPlayerState.preparing);

      await _setupPlayer(_cachedFilePath!);
    } catch (e) {
      debugPrint('Error preparing audio: $e');
      if (!mounted) return;
      setState(() {
        _audioState = AudioPlayerState.error;
        _errorMessage = 'Failed to load';
      });
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
      noOfSamples: 40,
      path: path,
      shouldExtractWaveform: true,
    );

    final int totalMs = await _playerController.getDuration(DurationType.max);
    if (!mounted) return;
    setState(() {
      _totalDur = Duration(milliseconds: totalMs);
      _audioState = AudioPlayerState.ready;
    });
  }

  Future<void> _pausePlayer() async {
    await _playerController.pausePlayer();
    _playPauseController.reverse();
    if (_currentlyPlayingController == _playerController) {
      _currentlyPlayingController = null;
    }
    if (mounted) {
      setState(() => _audioState = AudioPlayerState.paused);
    }
  }

  Future<void> _playPause() async {
    final SendMessageProvider messageProvider =
        context.read<SendMessageProvider>();

    if (messageProvider.isRecordingAudio.value) return;

    // Handle error state - retry
    if (_audioState == AudioPlayerState.error) {
      _cachedFilePath = null;
      _prepareAudio();
      return;
    }

    // Don't allow interaction while loading
    if (_audioState == AudioPlayerState.downloading ||
        _audioState == AudioPlayerState.preparing) {
      return;
    }

    if (_audioState == AudioPlayerState.playing) {
      await _pausePlayer();
      return;
    }

    // Handle completed state - replay from beginning
    if (_audioState == AudioPlayerState.completed) {
      await _playerController.seekTo(0);
      setState(() => _currentPos = Duration.zero);
    }

    // Pause other active players
    onGlobalPlayChanged?.call(null);
    if (_currentlyPlayingController != null &&
        _currentlyPlayingController != _playerController) {
      await _currentlyPlayingController!.pausePlayer();
    }

    _currentlyPlayingController = _playerController;
    onGlobalPlayChanged?.call(_playerController);

    _playPauseController.forward();
    await _playerController.startPlayer(forceRefresh: true);
    if (mounted) {
      setState(() => _audioState = AudioPlayerState.playing);
    }
  }

  Future<void> _seekTo(double value) async {
    if (_audioState == AudioPlayerState.downloading ||
        _audioState == AudioPlayerState.preparing ||
        _audioState == AudioPlayerState.error) {
      return;
    }

    final int seekMs = (value * _totalDur.inMilliseconds).toInt();
    await _playerController.seekTo(seekMs);

    // If completed and seeking, change state to paused
    if (_audioState == AudioPlayerState.completed) {
      setState(() {
        _currentPos = Duration(milliseconds: seekMs);
        _audioState = AudioPlayerState.paused;
      });
    } else {
      setState(() => _currentPos = Duration(milliseconds: seekMs));
    }
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _completeSub?.cancel();
    _playPauseController.dispose();
    _loadingController.dispose();
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
        constraints: const BoxConstraints(maxWidth: 280, minWidth: 200),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: _buildContent(isMe, colorScheme, theme),
      ),
    );
  }

  Widget _buildContent(bool isMe, ColorScheme colorScheme, ThemeData theme) {
    final bool isLoading = _audioState == AudioPlayerState.initial ||
        _audioState == AudioPlayerState.downloading ||
        _audioState == AudioPlayerState.preparing;

    if (isLoading) {
      return _buildLoadingUI(colorScheme, theme);
    }

    if (_audioState == AudioPlayerState.error) {
      return _buildErrorUI(colorScheme, theme);
    }

    return _buildPlayerUI(isMe, colorScheme, theme);
  }

  Widget _buildLoadingUI(ColorScheme colorScheme, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildLoadingButton(colorScheme, theme),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildShimmerWaveform(colorScheme),
              const SizedBox(height: 4),
              Row(
                children: <Widget>[
                  Text(
                    _audioState == AudioPlayerState.downloading
                        ? '${(_downloadProgress * 100).toInt()}%'
                        : '...',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 11,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      value: _downloadProgress > 0 ? _downloadProgress : null,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorUI(ColorScheme colorScheme, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: _playPause,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.error.withValues(alpha: 0.1),
            ),
            child: Icon(
              Icons.refresh_rounded,
              color: colorScheme.error,
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildStaticWaveform(colorScheme, isError: true),
              const SizedBox(height: 4),
              Text(
                _errorMessage ?? 'Tap to retry',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerUI(bool isMe, ColorScheme colorScheme, ThemeData theme) {
    final bool isPlaying = _audioState == AudioPlayerState.playing;
    final bool isCompleted = _audioState == AudioPlayerState.completed;
    final double _ = _totalDur.inMilliseconds > 0
        ? _currentPos.inMilliseconds / _totalDur.inMilliseconds
        : 0.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Play/Pause Button - WhatsApp style
        GestureDetector(
          onTap: _playPause,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.primaryColor,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                isPlaying
                    ? Icons.pause_rounded
                    : (isCompleted
                        ? Icons.replay_rounded
                        : Icons.play_arrow_rounded),
                key: ValueKey<AudioPlayerState>(_audioState),
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Waveform and Duration
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Waveform with slider
              SizedBox(
                height: 32,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        final double seekValue =
                            (details.localPosition.dx / constraints.maxWidth)
                                .clamp(0.0, 1.0);
                        _seekTo(seekValue);
                      },
                      onHorizontalDragUpdate: (DragUpdateDetails details) {
                        final double seekValue =
                            (details.localPosition.dx / constraints.maxWidth)
                                .clamp(0.0, 1.0);
                        _seekTo(seekValue);
                      },
                      child: AudioFileWaveforms(
                        enableSeekGesture: true,
                        continuousWaveform: false,
                        waveformType: WaveformType.fitWidth,
                        size: Size(constraints.maxWidth, 32),
                        playerController: _playerController,
                        playerWaveStyle: PlayerWaveStyle(
                          scaleFactor: 60,
                          fixedWaveColor:
                              colorScheme.onSurface.withValues(alpha: 0.25),
                          liveWaveColor: theme.primaryColor,
                          spacing: 4,
                          waveThickness: 3,
                          showSeekLine: false,
                          waveCap: StrokeCap.round,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 4),
              // Duration row
              Row(
                children: <Widget>[
                  Text(
                    isPlaying || _currentPos.inMilliseconds > 0
                        ? DurationFormatHelper.format(_currentPos)
                        : DurationFormatHelper.format(_totalDur),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 11,
                      fontFeatures: const <FontFeature>[
                        FontFeature.tabularFigures(),
                      ],
                    ),
                  ),
                  if (isPlaying || _currentPos.inMilliseconds > 0) ...<Widget>[
                    Text(
                      ' / ',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      DurationFormatHelper.format(_totalDur),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                        fontSize: 11,
                        fontFeatures: const <FontFeature>[
                          FontFeature.tabularFigures(),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(),
                  // Playing indicator
                  if (isPlaying) _buildPlayingBars(theme),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingButton(ColorScheme colorScheme, ThemeData theme) {
    return AnimatedBuilder(
      animation: _loadingController,
      builder: (BuildContext context, Widget? child) {
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.onSurface.withValues(alpha: 0.08),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // Rotating arc
              Transform.rotate(
                angle: _loadingController.value * 2 * math.pi,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    value: _downloadProgress > 0 ? _downloadProgress : null,
                    backgroundColor: Colors.transparent,
                    color: theme.primaryColor.withValues(alpha: 0.7),
                  ),
                ),
              ),
              Icon(
                Icons.mic,
                color: colorScheme.onSurface.withValues(alpha: 0.4),
                size: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerWaveform(ColorScheme colorScheme) {
    return AnimatedBuilder(
      animation: _loadingController,
      builder: (BuildContext context, Widget? child) {
        return SizedBox(
          height: 28,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List<Widget>.generate(25, (int index) {
              // Create wave pattern
              final double baseHeight = 8 + (math.sin(index * 0.5) * 6);
              final double animatedHeight = baseHeight *
                  (0.4 +
                      0.6 *
                          math.sin(
                            _loadingController.value * 2 * math.pi +
                                index * 0.3,
                          ).abs());

              return Container(
                width: 2.5,
                height: animatedHeight.clamp(4.0, 24.0),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildStaticWaveform(ColorScheme colorScheme, {bool isError = false}) {
    return SizedBox(
      height: 28,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List<Widget>.generate(25, (int index) {
          final double height = 8 + (math.sin(index * 0.5) * 6);
          return Container(
            width: 2.5,
            height: height.clamp(4.0, 20.0),
            decoration: BoxDecoration(
              color: isError
                  ? colorScheme.error.withValues(alpha: 0.3)
                  : colorScheme.onSurface.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPlayingBars(ThemeData theme) {
    return AnimatedBuilder(
      animation: _loadingController,
      builder: (BuildContext context, Widget? child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List<Widget>.generate(3, (int index) {
            final double height = 4 +
                8 *
                    math.sin(
                      _loadingController.value * 2 * math.pi + index * 0.8,
                    ).abs();
            return AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 2.5,
              height: height,
              margin: EdgeInsets.only(left: index > 0 ? 2 : 0),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.circular(1),
              ),
            );
          }),
        );
      },
    );
  }
}
