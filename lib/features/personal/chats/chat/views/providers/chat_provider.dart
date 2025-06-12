import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/media_preview/view/screens/media_preview_screen.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../../attachment/domain/entities/picked_attachment_option.dart';
import '../../../../../attachment/views/screens/pickable_attachment_screen.dart';
import '../../../../listing/listing_form/views/widgets/attachment_selection/cept_group_invite_usecase.dart';
import '../../../chat_dashboard/data/sources/local/local_chat.dart';
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
    this._acceptGroupInviteUsecase,
  );
  final GetMessagesUsecase _getMessagesUsecase;
  final SendMessageUsecase _sendMessageUsecase;
      final AcceptGorupInviteUsecase _acceptGroupInviteUsecase;
  ChatEntity? _chat;
  MessageLastEvaluatedKeyEntity? _key;
  GettedMessageEntity? _gettedMessage;
  DateTime? _chatAt;
  bool _isLoading = false;
  bool isRecordingAudio  =false;
  final TextEditingController _message = TextEditingController();
  final FocusNode focusNode = FocusNode();
  TextSelection lastSelection = const TextSelection.collapsed(offset: 0);
  final List<PickedAttachment> _attachments = <PickedAttachment>[];
  
//
  List<PickedAttachment> get attachments => _attachments;
  GettedMessageEntity? get gettedMessage => _gettedMessage;
  TextEditingController get message => _message;

  DateTime? get chatAT => _chatAt;
  ChatEntity? get chat => _chat;
  bool get isLoading => _isLoading;
//
  set isLoading(bool value) {
    _isLoading = value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

 void startRecording() {
    isRecordingAudio = true;
    notifyListeners();
  }

  void stopRecording() {
    isRecordingAudio = false;
    notifyListeners();
  }

 void onTextChange(String value) {
  lastSelection = _message.selection;
  notifyListeners(); // optional
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

 void setChat(ChatEntity? value) {
  _chat = value;
  _key = MessageLastEvaluatedKeyModel(
    chatID: _chat?.chatId ?? '',
    createdAt: 'null',
  );
  _gettedMessage = GettedMessageEntity(
    chatID: _chat?.chatId ?? '',
    lastEvaluatedKey: _key!,
    messages: <MessageEntity>[],
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
 
 Future<void> acceptGroupInvite(BuildContext context) async {
  final DataState<bool> result = await _acceptGroupInviteUsecase.call(chat?.chatId ?? '');
  try {
  if (result is DataSuccess) {
  setChat( LocalChat().chatEntity(chat?.chatId ?? ''));
  debugPrint('provider chat is updated');
  notifyListeners();
  } else {
    AppSnackBar.showSnackBar(
      context,
      result.exception?.message ?? 'something_wrong'.tr(),
    );
  }
} catch (e,stc) {
  AppLog.error('error chatprovider - acceptinvite',error: e,stackTrace: stc);
}}

}
