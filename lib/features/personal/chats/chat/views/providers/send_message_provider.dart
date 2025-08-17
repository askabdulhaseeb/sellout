import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../../attachment/domain/entities/picked_attachment_option.dart';
import '../../../../../attachment/views/screens/pickable_attachment_screen.dart';
import '../../../chat_dashboard/data/models/chat/chat_model.dart';
import '../../domain/params/send_message_param.dart';
import '../../domain/usecase/send_message_usecase.dart';

class SendMessageProvider extends ChangeNotifier {
  SendMessageProvider(
    this._sendMessageUsecase,
  );
  final SendMessageUsecase _sendMessageUsecase;

  //varibales
  bool _isLoading = false;
  ChatEntity? _chat;
  final ValueNotifier<bool> isRecordingAudio = ValueNotifier<bool>(false);
  final TextEditingController _message = TextEditingController();
  final List<PickedAttachment> _attachments = <PickedAttachment>[];
  final List<PickedAttachment> _document = <PickedAttachment>[];
  final List<PickedAttachment> _contact = <PickedAttachment>[];

  TextSelection lastSelection = const TextSelection.collapsed(offset: 0);

  //getters
  bool get isLoading => _isLoading;
  ChatEntity? get chat => _chat;
  List<PickedAttachment> get attachments => _attachments;
  List<PickedAttachment> get document => _document;
  List<PickedAttachment> get contact => _contact;
  TextEditingController get message => _message;
  // set functions
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setChat(ChatEntity? val) {
    _chat = val;
  }

  void startRecording() {
    isRecordingAudio.value = true;
    notifyListeners();
  }

  void stopRecording() {
    isRecordingAudio.value = false;
    notifyListeners();
  }

  void onTextChange(String value) {
    lastSelection = _message.selection;
    notifyListeners();
  }

  void handleMessageChange(String value) {
    final bool wasEmpty = message.text.isEmpty;
    final bool isNowEmpty = value.isEmpty;

    if (wasEmpty != isNowEmpty) {
      notifyListeners();
    }

    message.text = value;
  }

  void insertEmoji(String emoji) {
    final String text = _message.text;
    final TextSelection selection = lastSelection;

    final String newText = text.replaceRange(
      selection.start,
      selection.end,
      emoji,
    );

    final int newSelection = selection.start + emoji.length;

    _message.value = _message.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newSelection),
    );

    notifyListeners();
  }

  Future<void> setImages(
    BuildContext context, {
    required AttachmentType type,
  }) async {
    final List<PickedAttachment> selectedMedia =
        _attachments.where((PickedAttachment element) {
      return element.selectedMedia != null;
    }).toList();
    final List<PickedAttachment>? files =
        await Navigator.of(context).push<List<PickedAttachment>>(
      MaterialPageRoute<List<PickedAttachment>>(builder: (_) {
        return PickableAttachmentScreen(
          option: PickableAttachmentOption(
            maxAttachments: 10,
            allowMultiple: true,
            type: type,
            selectedMedia: selectedMedia
                .map((PickedAttachment e) => e.selectedMedia!)
                .toList(),
          ),
        );
      }),
    );
    if (files != null) {
      for (final PickedAttachment file in files) {
        final int index = _attachments.indexWhere((PickedAttachment element) =>
            element.selectedMedia == file.selectedMedia);
        if (index == -1) {
          _attachments.add(file);
        }
      }
      notifyListeners();
    }
  }

  void removePickedAttachment(PickedAttachment attachment) {
    _attachments.remove(attachment);
    notifyListeners();
  }

  void addAttachment(PickedAttachment attachment) {
    _attachments.add(attachment);
    notifyListeners();
  }

  void clearAttachments() {
    _attachments.clear();
    notifyListeners();
  }

  void addDocument(PickedAttachment attachment) {
    _document.add(attachment);
    notifyListeners();
  }

  void addContact(PickedAttachment attachment) {
    _contact.add(attachment);
    notifyListeners();
  }

  Future<void> sendMessage(BuildContext context) async {
    setLoading(true);
    final SendMessageParam param = SendMessageParam(
      chatID: _chat?.chatId ?? '',
      text: _message.text.isEmpty ? 'null' : _message.text,
      persons: _chat?.persons ?? <String>[],
      files: _attachments,
      source: 'application',
    );
    final DataState<bool> result = await _sendMessageUsecase(param);
    if (result is DataSuccess) {
      _message.clear();
      _attachments.clear();
      setLoading(false);
    } else {
      AppSnackBar.showSnackBar(
          // ignore: use_build_context_synchronously
          context,
          result.exception?.message ?? 'something_wrong'.tr());
    }
    setLoading(false);
  }

  Future<void> sendDocument(BuildContext context) async {
    setLoading(true);
    final SendMessageParam param = SendMessageParam(
      chatID: _chat?.chatId ?? '',
      text: 'null',
      persons: _chat?.persons ?? <String>[],
      files: _document,
      source: 'application',
    );
    final DataState<bool> result = await _sendMessageUsecase(param);
    if (result is DataSuccess) {
      _document.clear();
      setLoading(false);
    } else {
      AppSnackBar.showSnackBar(
          // ignore: use_build_context_synchronously
          context,
          result.exception?.message ?? 'something_wrong'.tr());
    }
    setLoading(false);
  }

  Future<void> sendContact(BuildContext context) async {
    setLoading(true);
    final SendMessageParam param = SendMessageParam(
      chatID: _chat?.chatId ?? '',
      text: 'null',
      persons: _chat?.persons ?? <String>[],
      files: _contact,
      source: 'application',
    );
    final DataState<bool> result = await _sendMessageUsecase(param);
    if (result is DataSuccess) {
      _contact.clear();
      setLoading(false);
    } else {
      AppSnackBar.showSnackBar(
          // ignore: use_build_context_synchronously
          context,
          result.exception?.message ?? 'something_wrong'.tr());
    }
    setLoading(false);
  }
}
