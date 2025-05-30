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

  final RecorderController recorderController = RecorderController();
  bool isRecording = false;

  Future<void> startRecording(BuildContext context) async {
    if (!await _checkPermission(context)) return;

    isRecording = true;
    await recorderController.record();
    notifyListeners();
  }

  Future<String?> stopRecording() async {
    isRecording = false;
    final path = await recorderController.stop();
    notifyListeners();
    return path;
  }

  Future<bool> _checkPermission(BuildContext context) async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Microphone access required'.tr())));
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    recorderController.dispose();
    super.dispose();
  }
}
