import 'dart:async';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/media_preview/view/screens/media_preview_screen.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../chat_dashboard/domain/entities/chat/chat_entity.dart';
import '../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../data/models/message_last_evaluated_key.dart';
import '../../domain/entities/getted_message_entity.dart';
import '../../domain/entities/message_last_evaluated_key_entity.dart';
import '../../domain/params/send_message_param.dart';
import '../../domain/usecase/get_messages_usecase.dart';
import '../../domain/usecase/send_message_usecase.dart';

class ChatProvider extends ChangeNotifier {
  ChatProvider(
    this._getMessagesUsecase,
    this._sendMessageUsecase,
  );
  final GetMessagesUsecase _getMessagesUsecase;
  final SendMessageUsecase _sendMessageUsecase;

  ChatEntity? _chat;
  ChatEntity? get chat => _chat;

  DateTime? _chatAt;
  DateTime? get chatAT => _chatAt;



  final List<PickedAttachment> _attachments = <PickedAttachment>[];
  List<PickedAttachment> get attachments => _attachments;
  MessageLastEvaluatedKeyEntity? _key;
  GettedMessageEntity? _gettedMessage;
  GettedMessageEntity? get gettedMessage => _gettedMessage;
  final TextEditingController _message = TextEditingController();
  TextEditingController get message => _message;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  onTextChange(String value) {
    if (value.isEmpty) {
      notifyListeners();
    } else if (value.length == 1) {
      notifyListeners();
    }
    return;
  }

  set chat(ChatEntity? value) {
    _chat = value;
    _key = MessageLastEvaluatedKeyModel(
      chatID: _chat?.chatId ?? '',
      createdAt: 'null',
    );
    _gettedMessage = GettedMessageEntity(
      chatID: _chat?.chatId ?? '',
      lastEvaluatedKey: _key ??
          MessageLastEvaluatedKeyModel(
            chatID: _chat?.chatId ?? '',
            createdAt: 'null',
          ),
      messages: <MessageEntity>[],
    );
    notifyListeners();
  }

  void removePickedAttachment(PickedAttachment attachment) {
    _attachments.remove(attachment);
    notifyListeners();
  }

  Future<bool> getMessages() async {
    _isLoading = true;
    final DataState<GettedMessageEntity> result =
        await _getMessagesUsecase(_gettedMessage?.lastEvaluatedKey ??
            _key ??
            MessageLastEvaluatedKeyModel(
              chatID: _chat?.chatId ?? '',
              createdAt: 'null',
            ));
    if (result is DataSuccess) {
      _gettedMessage = result.entity;
      _isLoading = false;
      return true;
    } else {
      AppLog.error(
        'New Getter: ERROR ${_gettedMessage?.lastEvaluatedKey?.paginationKey}',
        name: 'ChatProvider.getMessages - else',
        error: result.exception,
      );
      // Show error message
      _isLoading = false;
      return false;
    }
  }

  Future<bool> loadMessages() async {
    if (_gettedMessage?.lastEvaluatedKey?.paginationKey == null || _isLoading) {
      return true;
    }
    return await getMessages();
  }

  void addAttachment(PickedAttachment attachment) {
    _attachments.add(attachment);
    notifyListeners();
  }

  void clearAttachments() {
    _attachments.clear();
    notifyListeners();
  }

  Future<void> sendMessage(BuildContext context) async {
    final SendMessageParam param = SendMessageParam(
      chatID: _chat?.chatId ?? _key?.chatID ?? '',
      text: _message.text,
      persons: _chat?.persons ?? <String>[],
      files: _attachments,
      source: 'application',
    );
    final DataState<bool> result = await _sendMessageUsecase(param);
    if (result is DataSuccess) {
      _message.clear();
      _attachments.clear();
      notifyListeners();
    } else {
      AppSnackBar.showSnackBar(
          // ignore: use_build_context_synchronously
          context,
          result.exception?.message ?? 'something_wrong'.tr());
    }
  }

  void setImages(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<ReviewMediaPreviewScreen>(
        builder: (_) => ReviewMediaPreviewScreen(
          attachments: attachments,
        ),
      ),
    );
    notifyListeners();
  }
//-----------------------------Audio Recording Widget
  final RecorderController recorderController = RecorderController();
  bool _isPaused = false;
  bool _isRecording = false;
  bool _isLocked = false;
  bool _showDelete = false;
  Duration _recordingDuration = Duration.zero;
  Timer? _timer;
  final bool _isSending = false;

  bool get isRecording => _isRecording;
  bool get isLocked => _isLocked;
  bool get showDelete => _showDelete;
  Duration get recordingDuration => _recordingDuration;
  bool get isSending => _isSending;
 void setRecording(bool value){
  _isRecording = value;
 }
  Future<void> requestMicPermission() async {
    final PermissionStatus status = await Permission.microphone.status;
    if (!status.isGranted) {
      final PermissionStatus result = await Permission.microphone.request();
      if (!result.isGranted) {
        throw Exception('Microphone permission not granted');
      }
    }
  }

  Future<void> startRecording() async {
    if (_isRecording) return;
    
    try {
      await requestMicPermission();
      
      _isRecording = true;
      _isPaused = false;
      _isLocked = false;
      _showDelete = false;
      _recordingDuration = Duration.zero;
      
      await recorderController.record();
      _startTimer();
      notifyListeners();
    } catch (e) {
      _resetRecordingState();
      rethrow;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _recordingDuration += const Duration(seconds: 1);
      notifyListeners();
    });
  }

  void cancelRecording() {
    _timer?.cancel();
    _resetRecordingState();
    recorderController.reset();
    notifyListeners();
  }

  void toggleLock() {
    _isLocked = !_isLocked;
    notifyListeners();
  }

  Future<void> togglePauseResume() async {
    if (!_isRecording) return;

    if (_isPaused) {
      await recorderController.record();
    } else {
      await recorderController.pause();
    }
    
    _isPaused = !_isPaused;
    notifyListeners();
  }

  void _resetRecordingState() {
    _timer?.cancel();
    _isRecording = false;
    _isPaused = false;
    _isLocked = false;
    _showDelete = false;
    _recordingDuration = Duration.zero;
  }

  void disposed() {
    _timer?.cancel();
    recorderController.dispose();
    super.dispose();
  }
}
