import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import '../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../provider/promo_provider.dart';

class CustomCameraScreen extends StatefulWidget {
  const CustomCameraScreen({super.key});

  @override
  State<CustomCameraScreen> createState() => _CustomCameraScreenState();
}

class _CustomCameraScreenState extends State<CustomCameraScreen> {
  CameraController? _controller;
  late List<CameraDescription> _cameras;
  int _currentCameraIndex = 0;
  bool _isRecording = false;
  bool _isCapturingPhoto = false;
  Timer? _timer;
  int _recordingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      await _startCamera(_cameras[_currentCameraIndex]);
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<void> _startCamera(CameraDescription camera) async {
    await _controller?.dispose();
    _controller = CameraController(camera, ResolutionPreset.high);
    try {
      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Camera start error: $e');
    }
  }

  Future<void> _switchCamera() async {
    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;
    await _startCamera(_cameras[_currentCameraIndex]);
  }

  Future<File> _saveFile(XFile xfile, {required bool isVideo}) async {
    final String extension = isVideo ? '.mp4' : '.jpg';
    final String fileName =
        'promo_recorder_${DateTime.now().millisecondsSinceEpoch}$extension';
    final String newPath = xfile.path.replaceAll(
      path.basename(xfile.path),
      fileName,
    );
    final File saved = await File(xfile.path).copy(newPath);
    debugPrint('✅ Saved as: $fileName');
    return saved;
  }

  Future<void> _capturePhoto() async {
    if (_isCapturingPhoto ||
        _controller == null ||
        !_controller!.value.isInitialized) {
      return;
    }

    _isCapturingPhoto = true;
    try {
      final XFile xfile = await _controller!.takePicture();
      final File savedFile = await _saveFile(xfile, isVideo: false);
      _attachFile(savedFile, AttachmentType.image);
    } catch (e) {
      debugPrint('Photo capture error: $e');
    } finally {
      _isCapturingPhoto = false;
    }
  }

  Future<void> _toggleRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      if (_isRecording) {
        final XFile xfile = await _controller!.stopVideoRecording();
        await Future.delayed(const Duration(milliseconds: 300));
        final File savedFile = await _saveFile(xfile, isVideo: true);
        _attachFile(savedFile, AttachmentType.video);
        _stopTimer();
        setState(() => _isRecording = false);
      } else {
        await _controller!.startVideoRecording();
        _startTimer();
        setState(() => _isRecording = true);
      }
    } catch (e) {
      debugPrint('Video recording error: $e');
    }
  }

  void _startTimer() {
    _recordingSeconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _recordingSeconds++);
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _attachFile(File file, AttachmentType type) {
    Provider.of<PromoProvider>(context, listen: false).setAttachments(
      PickedAttachment(file: file, type: type),
    );
  }

  Future<void> _pickFromGallery() async {
    Provider.of<PromoProvider>(context, listen: false).pickFromGallery(
      context,
      type: AttachmentType.media,
    );
  }

  Future<void> _toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    final FlashMode newMode = _controller!.value.flashMode == FlashMode.torch
        ? FlashMode.off
        : FlashMode.torch;
    await _controller!.setFlashMode(newMode);

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
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
          _buildTopBar(),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
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
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
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
    );
  }

  String _formatTime(int seconds) {
    final String min = (seconds ~/ 60).toString().padLeft(2, '0');
    final String sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }
}
