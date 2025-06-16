import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/enums/core/attachment_type.dart';
import '../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../provider/promo_provider.dart';

class CustomCameraScreen extends StatefulWidget {
  const CustomCameraScreen({super.key});

  @override
  State<CustomCameraScreen> createState() => _CustomCameraScreenState();
}

class _CustomCameraScreenState extends State<CustomCameraScreen> {
  CameraController? _controller;
  bool _isRecording = false;
  bool _isCapturingPhoto = false;
  late List<CameraDescription> _cameras;
  int _currentCameraIndex = 0;
  Timer? _timer;
  int _recordingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    await _startCamera(_cameras[_currentCameraIndex]);
  }

  Future<void> _startCamera(CameraDescription camera) async {
    try {
      // Dispose previous controller safely
      await _controller?.dispose();

      _controller = CameraController(camera, ResolutionPreset.high);
      await _controller!.initialize();

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<void> _switchCamera() async {
    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;
    await _startCamera(_cameras[_currentCameraIndex]);
  }

  Future<void> _capturePhoto() async {
    if (_isCapturingPhoto) return;
    if (!mounted ||
        _controller == null ||
        !_controller!.value.isInitialized ||
        _controller!.value.isTakingPicture) {
      debugPrint('Camera not ready or busy');
      return;
    }

    _isCapturingPhoto = true;
    try {
      final XFile file = await _controller!.takePicture();
      if (!mounted) return;

      Provider.of<PromoProvider>(context, listen: false).setAttachments(
        PickedAttachment(file: file, type: AttachmentType.media),
      );
    } catch (e) {
      debugPrint('Error capturing photo: $e');
    } finally {
      _isCapturingPhoto = false;
    }
  }

  Future<void> _toggleRecording() async {
    if (!mounted || _controller == null || !_controller!.value.isInitialized)
      return;

    try {
      if (_isRecording) {
        final XFile file = await _controller!.stopVideoRecording();
        if (!mounted) return;

        Provider.of<PromoProvider>(context, listen: false).setAttachments(
          PickedAttachment(file: file, type: AttachmentType.media),
        );

        _stopTimer();
        setState(() => _isRecording = false);
      } else {
        await _controller!.startVideoRecording();
        _startTimer();
        setState(() => _isRecording = true);
      }
    } catch (e) {
      debugPrint('Error with video recording: $e');
    }
  }

  void _startTimer() {
    _recordingSeconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _recordingSeconds++;
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  Future<void> _pickFromGallery() async {
    Provider.of<PromoProvider>(context, listen: false).pickVideoFromGallery(
      context,
      type: AttachmentType.media,
    );
  }

  Future<void> _toggleFlash() async {
    // Assuming you have toggleFlash function in your PromoProvider
    Provider.of<PromoProvider>(context, listen: false).toggleFlash();
    if (_controller != null && _controller!.value.isInitialized) {
      await _controller!.setFlashMode(
        _controller!.value.flashMode == FlashMode.torch
            ? FlashMode.off
            : FlashMode.torch,
      );
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CameraPreview(_controller!),
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
                  onPressed: _switchCamera,
                ),
                IconButton(
                  icon: Icon(
                    _controller!.value.flashMode == FlashMode.torch
                        ? Icons.flash_on
                        : Icons.flash_off,
                    color: Colors.white,
                  ),
                  onPressed: _toggleFlash,
                ),
                if (_isRecording)
                  Text(
                    _formatTime(_recordingSeconds),
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  onTap: _pickFromGallery,
                  child: const CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: Icon(Icons.photo_library, color: Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: _capturePhoto,
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.camera_alt, color: Colors.black),
                  ),
                ),
                GestureDetector(
                  onTap: _toggleRecording,
                  child: CircleAvatar(
                    backgroundColor: _isRecording ? Colors.red : Colors.black45,
                    child: Icon(
                      _isRecording ? Icons.stop : Icons.videocam,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final String min = (seconds ~/ 60).toString().padLeft(2, '0');
    final String sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }
}
