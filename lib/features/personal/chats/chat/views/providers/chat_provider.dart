import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/functions/app_log.dart';
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
import '../../domain/params/leave_group_params.dart';
import '../../domain/params/send_invite_to_group_params.dart';
import '../../domain/params/send_message_param.dart';
import '../../domain/usecase/get_messages_usecase.dart';
import '../../domain/usecase/leave_group_usecase.dart';
import '../../domain/usecase/send_group_invite_usecase.dart';
import '../../domain/usecase/send_message_usecase.dart';

class ChatProvider extends ChangeNotifier {
  ChatProvider(
    this._getMessagesUsecase,
    this._sendMessageUsecase,
    this._acceptGroupInviteUsecase,
    this._leaveGroupparams,
    this._sendGroupInviteUsecase,
  );
  final GetMessagesUsecase _getMessagesUsecase;
  final SendMessageUsecase _sendMessageUsecase;
      final AcceptGorupInviteUsecase _acceptGroupInviteUsecase;
      final LeaveGroupUsecase _leaveGroupparams;
      final SendGroupInviteUsecase _sendGroupInviteUsecase;
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
  void setLoading(bool value) {
    _isLoading = value;
      notifyListeners();
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
//
  Future<void> sendMessage(BuildContext context) async {
    setLoading(true);
    final SendMessageParam param = SendMessageParam(
      chatID: _chat?.chatId ?? _key?.chatID ?? '',
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
    }setLoading(false);
  }

 Future<void> acceptGroupInvite(BuildContext context) async {
  setLoading(true);
  final DataState<bool> result = await _acceptGroupInviteUsecase.call(chat?.chatId ?? '');
  try {
  if (result is DataSuccess) {
  setChat( LocalChat().chatEntity(chat?.chatId ?? ''));
  debugPrint('provider chat is updated');
setLoading(false);  } else {
    AppSnackBar.showSnackBar(
      context,
      result.exception?.message ?? 'something_wrong'.tr(),
    );setLoading(false); 
          AppLog.error('you accepted group invite',name: 'ChatPRovider.LeaveGroup - else');
  }
} catch (e,stc) {
      AppLog.error('failed to accept invite',name: 'ChatPRovider.LeaveGroup - else',error: e,stackTrace: stc);
  setLoading(false); 
}}

 Future<void> leaveGroup() async {
  setLoading(true); 
LeaveGroupParams   leaveparams = LeaveGroupParams(chatId: chat?.chatId ?? '',removalType: 'leave');
  final DataState<bool> result = await _leaveGroupparams.call(leaveparams);
  try {
  if (result is DataSuccess) {
  setChat( LocalChat().chatEntity(chat?.chatId ?? ''));
  debugPrint('you left the group${leaveparams.chatId}');
  setLoading(false); 
  } else {
      AppLog.error('you failed to leave the group${leaveparams.chatId}',name: 'ChatPRovider.LeaveGroup - else');
    setLoading(false); 
  }
} catch (e,stc) {
  AppLog.error('error chatprovider - LeaveGroup',name:'ChatPRovider.LeaveGroup - Catch' ,error: e,stackTrace: stc);
  setLoading(false); 
}}

 Future<void> sendGroupInvite(List<String> newParticipant) async {
  setLoading(true);
SendGroupInviteParams   inviteparams = SendGroupInviteParams(chatId: chat?.chatId ?? '',newParticipants: newParticipant);
  final DataState<bool> result = await _sendGroupInviteUsecase.call(inviteparams);
  try {
  if (result is DataSuccess) {
  setChat( LocalChat().chatEntity(chat?.chatId ?? ''));
  debugPrint('you invited${inviteparams.newParticipants} to ${inviteparams.chatId}');
  setLoading(false); 
  } else {
      AppLog.error('you failed to invite to the group${inviteparams.chatId}',name: 'ChatPRovider.sendGroupInvite - else');
    setLoading(false); 
  }
} catch (e,stc) {
  AppLog.error('error chatprovider - sendGroupInvite',name:'ChatPRovider.sendGroupInvite - Catch' ,error: e,stackTrace: stc);
  setLoading(false); 
}}
}
