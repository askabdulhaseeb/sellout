import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  const VideoWidget({
    required this.videoSource,
    this.play = true,
    this.fit = BoxFit.cover,
    this.durationFontSize = 12,
    super.key,
    this.showTime = false,
  });

  final String videoSource; // File path or URL
  final bool play;
  final BoxFit fit;
  final double durationFontSize;
  final bool showTime;
  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController? _controller;
  bool _initialized = false;

  bool get _isNetwork => widget.videoSource.startsWith('http');

  @override
  void initState() {
    super.initState();

    _controller = _isNetwork
        ? VideoPlayerController.networkUrl(Uri.parse(widget.videoSource))
        : VideoPlayerController.file(File(widget.videoSource));

    _controller!.initialize().then((_) {
      if (mounted) {
        setState(() {
          _initialized = true;
        });
        if (widget.play) {
          _controller!.play();
        }
        _controller!.setLooping(true);
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String minutes = twoDigits(duration.inMinutes.remainder(60));
    final String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: FittedBox(
            fit: widget.fit,
            clipBehavior: Clip.hardEdge,
            child: Container(
              color: Colors.grey,
              width: _controller!.value.size.width,
              height: _controller!.value.size.height,
              child: VideoPlayer(_controller!),
            ),
          ),
        ),
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
        if (widget.showTime == true)
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
                _formatDuration(_controller!.value.duration),
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
