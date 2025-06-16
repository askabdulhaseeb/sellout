import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  const VideoWidget({
    required this.videoSource,
    this.play = true,
    this.fit = BoxFit.cover,
    this.durationFontSize = 12,
    super.key,
    this.showTime = false,
    this.borderRadius = 12,
  });

  final dynamic videoSource;
  final bool play;
  final BoxFit fit;
  final double durationFontSize;
  final bool showTime;
  final double borderRadius;

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
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      if (widget.videoSource is String) {
        final String src = widget.videoSource as String;
        if (src.startsWith('http')) {
          // Check if URL is valid
          final http.Response response = await http.head(Uri.parse(src));
          if (response.statusCode >= 400) {
            throw Exception('Invalid video URL or unreachable: $src');
          }
          _controller = VideoPlayerController.networkUrl(Uri.parse(src));
        } else {
          final File file = File(src);
          if (!await file.exists()) {
            throw Exception('Video file not found at path: $src');
          }
          _controller = VideoPlayerController.file(file);
        }
      } else if (widget.videoSource is File) {
        if (!await widget.videoSource.exists()) {
          throw Exception('File does not exist.');
        }
        _controller = VideoPlayerController.file(widget.videoSource);
      } else {
        throw Exception(
            'Unsupported video source type: ${widget.videoSource.runtimeType}');
      }

      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _initialized = true;
        });

        if (widget.play) _controller!.play();
        _controller!.setLooping(true);
      }
    } catch (e) {
      debugPrint('Video initialization error: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: _hasError
          ? _buildPlaceholder()
          : !_initialized
              ? _buildLoading()
              : _buildVideo(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey,
      height: 180,
      child: const Center(
        child: Icon(Icons.broken_image, color: Colors.red, size: 48),
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      color: Colors.grey,
      height: 180,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildVideo() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
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
        if (widget.showTime)
          Positioned(
            bottom: 6,
            right: 6,
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
