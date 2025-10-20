import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  const VideoWidget({
    required this.videoSource,
    super.key,
    this.play = true,
    this.fit = BoxFit.fill,
    this.showTime = true,
    this.square = false,
    this.durationFontSize = 12,
  });

  final dynamic videoSource;
  final bool play;
  final BoxFit fit;
  final bool showTime;
  final bool square;
  final double durationFontSize;

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _hasError = false;
  bool _ended = false;
  File? _tempMemoryFile;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      final dynamic src = widget.videoSource;

      // 1) Uri input
      if (src is Uri) {
        final String scheme = src.scheme.toLowerCase();
        if (scheme == 'http' || scheme == 'https') {
          _controller = VideoPlayerController.networkUrl(src);
        } else if (scheme == 'file') {
          _controller = VideoPlayerController.file(File(src.toFilePath()));
        } else if (scheme == 'content') {
          // Best-effort: try contentUri when available; fallback by reading to temp file
          try {
            // Some platforms support contentUri directly
            // ignore: deprecated_member_use
            _controller = VideoPlayerController.contentUri(src);
          } catch (_) {
            // Fallback: not supported -> fail fast
            throw Exception('Unsupported content URI: $src');
          }
        } else {
          throw Exception('Unsupported URI scheme: $scheme');
        }

        // 2) Network via String
      } else if (src is String &&
          (src.startsWith('http://') || src.startsWith('https://'))) {
        _controller = VideoPlayerController.networkUrl(Uri.parse(src));

        // 3) Local file path via String
      } else if (src is String && File(src).existsSync()) {
        _controller = VideoPlayerController.file(File(src));

        // 4) Asset path via String (e.g. assets/videos/foo.mp4)
      } else if (src is String) {
        _controller = VideoPlayerController.asset(src);

        // 5) Direct File
      } else if (src is File) {
        _controller = VideoPlayerController.file(src);

        // 6) Memory bytes (Uint8List) -> write to temp file then play
      } else if (src is Uint8List) {
        if (src.isEmpty) {
          throw Exception('Empty video bytes');
        }
        final String tmpPath =
            '${Directory.systemTemp.path}${Platform.pathSeparator}vid_${DateTime.now().millisecondsSinceEpoch}.mp4';
        final File f = File(tmpPath);
        await f.writeAsBytes(src, flush: true);
        _tempMemoryFile = f;
        _controller = VideoPlayerController.file(f);
      } else {
        throw Exception(
            'Unsupported source type: ${widget.videoSource.runtimeType}');
      }

      await _controller!.initialize();
      _controller!.setLooping(false);

      if (widget.play) {
        _controller!.play();
      }

      _controller!.addListener(() {
        if (mounted) {
          // detect when video ends
          final VideoPlayerValue v = _controller!.value;
          if (v.position >= v.duration && !v.isPlaying && !_ended) {
            setState(() => _ended = true);
          }
          setState(() {});
        }
      });

      if (mounted) setState(() => _initialized = true);
    } catch (e) {
      debugPrint('VideoWidget error: $e');
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    // Clean temp file if created for memory source
    if (_tempMemoryFile != null) {
      // best-effort cleanup
      try {
        _tempMemoryFile!.deleteSync();
      } catch (_) {}
    }
    super.dispose();
  }

  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
  }

  void _togglePlayPause() {
    if (_ended) {
      // if ended, replay from start
      _controller!.seekTo(Duration.zero);
      _controller!.play();
      setState(() => _ended = false);
    } else if (_controller!.value.isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Safe aspect ratio computation without touching controller before init
    final double safeAspectRatio = widget.square
        ? 1.0
        : (_initialized &&
                _controller != null &&
                _controller!.value.aspectRatio > 0
            ? _controller!.value.aspectRatio
            : 16 / 9);

    // Build a consistent layout wrapper so UI doesn't jump
    return AspectRatio(
      aspectRatio: safeAspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // 1) Error placeholder
          if (_hasError)
            _buildPlaceholder(
              icon: Icons.videocam_off,
              message: 'Video unavailable',
            )
          // 2) Loading placeholder
          else if (!_initialized)
            _buildPlaceholder(loading: true)
          // 3) Actual video
          else
            VideoPlayer(_controller!),

          // Play / Pause overlay (only when initialized and not error)
          if (!_hasError && _initialized && widget.play)
            GestureDetector(
              onTap: _togglePlayPause,
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: Icon(
                  _ended
                      ? Icons.replay
                      : (_controller!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow),
                  color: Colors.white,
                ),
              ),
            ),

          // Timer bottom right (only when initialized and not error)
          if (!_hasError && _initialized && widget.showTime)
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Builder(builder: (BuildContext context) {
                  final Duration position = _controller!.value.position;
                  final Duration duration = _controller!.value.duration;
                  return Text(
                    _controller!.value.isPlaying || _ended
                        ? '${_format(position)} / ${_format(duration)}'
                        : _format(duration),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.durationFontSize,
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder({
    bool loading = false,
    IconData icon = Icons.videocam,
    String message = 'Loading...',
  }) {
    return Container(
      color: Colors.black12,
      alignment: Alignment.center,
      child: loading
          ? const SizedBox(
              width: 32, height: 32, child: CircularProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(icon, size: 32, color: Colors.black45),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
    );
  }
}
