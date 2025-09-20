import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  const VideoWidget({
    super.key,
    required this.videoSource,
    this.play = true, // 👈 restored
    this.fit = BoxFit.cover,
    this.showTime = true,
    this.square = false,
    this.durationFontSize = 12,
  });

  final dynamic videoSource;
  final bool play; // 👈 restored
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

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      // Pick source
      if (widget.videoSource is Uri &&
              (widget.videoSource as Uri).isScheme('http') ||
          widget.videoSource is String &&
              (widget.videoSource as String).startsWith('http')) {
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
        throw Exception('Unsupported source');
      }

      await _controller!.initialize();
      _controller!.setLooping(true);

      if (widget.play) _controller!.play();

      _controller!.addListener(() {
        if (mounted) setState(() {});
      });

      if (mounted) setState(() => _initialized = true);
    } catch (e) {
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

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const Center(child: Icon(Icons.error, color: Colors.red));
    }
    if (!_initialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final aspectRatio = widget.square ? 1.0 : _controller!.value.aspectRatio;

    final position = _controller!.value.position;
    final duration = _controller!.value.duration;

    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: aspectRatio,
          child: FittedBox(
            fit: widget.fit,
            child: SizedBox(
              width: _controller!.value.size.width,
              height: _controller!.value.size.height,
              child: VideoPlayer(_controller!),
            ),
          ),
        ),
        // Play / Pause (but only if widget.play is true)
        if (widget.play)
          GestureDetector(
            onTap: () {
              setState(() {
                _controller!.value.isPlaying
                    ? _controller!.pause()
                    : _controller!.play();
              });
            },
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: Icon(
                _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
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
                '${_format(position)} / ${_format(duration)}',
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
