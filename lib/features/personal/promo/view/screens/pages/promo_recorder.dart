import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../provider/promo_provider.dart';

class PromoRecorderView extends StatefulWidget {
  const PromoRecorderView({super.key});

  @override
  State<PromoRecorderView> createState() => _PromoRecorderViewState();
}
class _PromoRecorderViewState extends State<PromoRecorderView> {
  @override
  void initState() {
    super.initState();
 WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<PromoProvider>(context, listen: false).initCamera();
  });
  }
// @override
// void deactivate() {
//   final PromoProvider provider = Provider.of<PromoProvider>(context, listen: false);
//   if (provider.isFlashOn) {
//     provider.toggleFlash();
//   }
//   super.deactivate();
// }
  @override
  Widget build(BuildContext context) {
    final PromoProvider provider = Provider.of<PromoProvider>(context);
    return PopScope(onPopInvokedWithResult: (bool didPop, dynamic result) {
  if (provider.isFlashOn) {
    provider.toggleFlash(); 
  }
  provider.disposeController(); },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: provider.cameraController == null ||
                !provider.cameraController!.value.isInitialized
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: <Widget>[
                  // Camera preview
                  Positioned.fill(
                    child: CameraPreview(provider.cameraController!),
                  ),
                  // Top controls
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 20,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Flash control
                        IconButton(
                          icon: Icon(
                            provider.isFlashOn ? Icons.flash_on : Icons.flash_off,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: provider.toggleFlash,
                        ),
                        
                        // Timer
                        if (provider.isRecording)
                          Text(
                            '00:${provider.recordingSeconds.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        
                        // Camera switch
                        IconButton(
                          icon: const Icon(Icons.cameraswitch, color: Colors.white, size: 30),
                          onPressed: provider.toggleCamera,
                        ),
                      ],
                    ),
                  ),
                  // Bottom controls
                  Positioned(
                    bottom: MediaQuery.of(context).padding.bottom + 30,
                    left: 30,
                    right: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Gallery button
                        GestureDetector(
                          onTap: () {
                             provider.pickVideoFromGallery(
                              context,
                              type: AttachmentType.video,
                            );
                          },
                          child: const CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.white24,
                            child: Icon(Icons.photo_library, color: Colors.white, size: 28),
                          ),
                        ),
                        // Record button
                        GestureDetector(
                          onTap: () {
                            if (provider.isRecording) {
                             provider.stopRecording();
                            } else {
                              provider.startRecording(context);
                            }
                          },
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: provider.isRecording ? Colors.red : Colors.white,
                                width: 4,
                              ),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: provider.isRecording ? Colors.red : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        // Empty space for layout balance
                        const SizedBox(width: 56),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}