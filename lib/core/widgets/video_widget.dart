import 'dart:io';
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
  bool _ended = false; // 👈 track if ended

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      if ((widget.videoSource is Uri &&
              (widget.videoSource as Uri).isScheme('http')) ||
          (widget.videoSource is String &&
              (widget.videoSource as String).startsWith('http'))) {
        final uri = widget.videoSource is Uri
            ? widget.videoSource
            : Uri.parse(widget.videoSource);
        _controller = VideoPlayerController.networkUrl(uri);
      } else if (widget.videoSource is Uri &&
          (widget.videoSource as Uri).isScheme('file')) {
        final Uri uri = widget.videoSource as Uri;
        _controller = VideoPlayerController.file(File(uri.toFilePath()));
      } else if (widget.videoSource is String) {
        _controller = VideoPlayerController.file(File(widget.videoSource));
      } else {
        throw Exception('Unsupported source type: ${widget.videoSource}');
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
    if (_hasError) {
      return const Center(child: Icon(Icons.error, color: Colors.red));
    }
    if (!_initialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final double aspectRatio = widget.square
        ? 1.0
        : (_controller!.value.aspectRatio == 0
            ? 16 / 9
            : _controller!.value.aspectRatio);

    final Duration position = _controller!.value.position;
    final Duration duration = _controller!.value.duration;

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        AspectRatio(
          aspectRatio: aspectRatio,
          child: VideoPlayer(_controller!),
        ),

        // Play / Pause overlay (tappable)
        if (widget.play)
          GestureDetector(
            onTap: _togglePlayPause,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: Icon(
                _ended
                    ? Icons.replay // if ended, show replay icon
                    : _controller!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                color: Colors.white,
              ),
            ),
          ),

        // Timer bottom right
        if (widget.showTime)
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _controller!.value.isPlaying || _ended
                    ? '${_format(position)} / ${_format(duration)}'
                    : _format(duration),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.durationFontSize,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
