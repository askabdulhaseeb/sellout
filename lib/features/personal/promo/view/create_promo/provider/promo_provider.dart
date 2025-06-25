import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../../../domain/entities/promo_entity.dart';
import '../../../domain/usecase/get_promo_of_followers_usecase.dart';
import 'dart:async';
import 'package:camera/camera.dart';
import '../../../../../attachment/domain/entities/picked_attachment_option.dart';
import '../../../../../attachment/views/screens/pickable_attachment_screen.dart';
import '../../../domain/params/create_promo_params.dart';
import '../../../domain/usecase/create_promo_usecase.dart';

class PromoProvider extends ChangeNotifier {
  PromoProvider(this.getPromoUsecase, this.createPromoUsecase);
  final GetPromoFollowerUseCase getPromoUsecase;
  final CreatePromoUsecase createPromoUsecase;

  List<PickedAttachment> attachments = <PickedAttachment>[];
  PostEntity? _post;
  PostEntity? get post => _post;
  List<PromoEntity>? _promoList;
  List<PromoEntity>? get promoList => _promoList;
  PickedAttachment? _thumbNail;
  PickedAttachment? get thumbNail => _thumbNail;

  int get pageNumber => attachment?.file == null ? 1 : 2;
  PickedAttachment? attachment;
  CameraController? cameraController;
  List<CameraDescription> cameras = <CameraDescription>[];
  bool isRecording = false;
  bool isRearCamera = true;
  bool isFlashOn = false;
  int recordingSeconds = 0;
  Timer? _timer;
  TextEditingController title = TextEditingController();
  TextEditingController price = TextEditingController();
  String referenceType = '';
  String _referenceId = '';
  String get referenceId => _referenceId;
  bool _isLoading = false;
  bool get isLoadig => _isLoading;
  String? errorMessage;
  void setRefernceID(String refID, String refType) {
    _referenceId = refID;
    referenceType = refType;
  }

  void setPost(PostEntity posts) {
    _post = posts;
    notifyListeners();
  }

  void setThumbNail(PickedAttachment value) {
    _thumbNail = value;
  }

  void clearPost() {
    _referenceId = '';
    referenceType = '';
    _post = null;
    notifyListeners();
  }

  CreatePromoParams get promoParams {
    return CreatePromoParams(
      thumbNail: _thumbNail,
      referenceType: 'post_attachment',
      referenceID: _referenceId,
      title: title.text,
      price: price.text,
      attachments: attachment,
    );
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras.first, ResolutionPreset.high);
    await cameraController?.initialize();
    notifyListeners();
  }

  Future<void> toggleCamera() async {
    isRearCamera = !isRearCamera;
    final CameraLensDirection direction =
        isRearCamera ? CameraLensDirection.back : CameraLensDirection.front;
    final CameraDescription camera = cameras
        .firstWhere((CameraDescription cam) => cam.lensDirection == direction);
    cameraController = CameraController(camera, ResolutionPreset.high);
    await cameraController?.initialize();
    notifyListeners();
  }

  Future<void> toggleFlash() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }
    isFlashOn = !isFlashOn;
    await cameraController!
        .setFlashMode(isFlashOn ? FlashMode.torch : FlashMode.off);
    notifyListeners();
  }

  Future<void> startRecording(BuildContext context) async {
    if (cameraController == null || cameraController!.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController!.startVideoRecording();
      isRecording = true;
      recordingSeconds = 0;
      notifyListeners();

      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        recordingSeconds++;
        notifyListeners();
      });
    } catch (e) {
      _timer?.cancel();
      isRecording = false;
      notifyListeners();
      debugPrint('Error recording video: $e');
    }
  }

  Future<File> _saveFileToDocuments(File file) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    String fileName = p.basename(file.path);

    // Ensure file has an extension to help with MIME type detection
    if (p.extension(fileName).isEmpty) {
      // Guess based on file type or default to .tmp
      if (fileName.contains('image')) {
        fileName = '$fileName.jpg';
      } else if (fileName.contains('video')) {
        fileName = '$fileName.mp4';
      } else {
        fileName = '$fileName.tmp';
      }
    }

    final String newPath = p.join(dir.path, fileName);
    final File savedFile = await file.copy(newPath);
    debugPrint('✅ File saved at: ${savedFile.path}');
    return savedFile;
  }

  Future<void> pickFromGallery(
    BuildContext context, {
    required AttachmentType type,
  }) async {
    final List<PickedAttachment>? files =
        await Navigator.of(context).push<List<PickedAttachment>>(
      MaterialPageRoute<List<PickedAttachment>>(
        builder: (_) => PickableAttachmentScreen(
          option: PickableAttachmentOption(
            maxAttachments: 0,
            allowMultiple: false,
            type: type,
          ),
        ),
      ),
    );

    if (files != null && files.isNotEmpty) {
      final File savedFile = await _saveFileToDocuments(files.first.file);
      setAttachments(
        PickedAttachment(file: savedFile, type: files.first.type),
      );
      notifyListeners();
    }
  }

  Future<void> pickThumbnailFromGallery(BuildContext context) async {
    final List<PickedAttachment>? files =
        await Navigator.of(context).push<List<PickedAttachment>>(
      MaterialPageRoute<List<PickedAttachment>>(
        builder: (_) => PickableAttachmentScreen(
          option: PickableAttachmentOption(
            maxAttachments: 0,
            allowMultiple: false,
            type: AttachmentType.image,
          ),
        ),
      ),
    );

    if (files != null && files.isNotEmpty) {
      final File savedFile = await _saveFileToDocuments(files.first.file);
      setThumbNail(
        PickedAttachment(file: savedFile, type: AttachmentType.image),
      );
      notifyListeners();
    }
  }

  void setAttachments(PickedAttachment newAttachments) {
    attachment = newAttachments;
    if (isFlashOn) toggleFlash();
    notifyListeners();
  }

  void disposeController() {
    cameraController?.dispose();
  }

  Future<void> createPromo(BuildContext context) async {
    _setLoading(true);
    errorMessage = null;
    final DataState<bool> result = await createPromoUsecase.call(promoParams);
    _setLoading(false);
    if (result is DataSuccess) {
      _setLoading(false);
      // ignore: use_build_context_synchronously
      Navigator.pop(context); // pop on success
    } else {
      errorMessage = result.exception?.message ?? 'Failed to create promo';
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getPromoOfFollower() async {
    _setLoading(true);
    try {
      final DataState<List<PromoEntity>> response =
          await getPromoUsecase.call(true);
      if (response is DataSuccess) {
        AppLog.info('Promo fetched successfully');
        _promoList = response.entity;
      } else {
        AppLog.error('Failed to fetch promo: ${response.exception?.message}');
      }
    } catch (e) {
      AppLog.error('Exception in getPromoOfFollower: $e');
    }

    _setLoading(false);
  }

  void reset() {
    attachment = null;
    _thumbNail = null;
    title.clear();
    price.clear();
    clearPost();
    if (isFlashOn) toggleFlash();
  }
}
