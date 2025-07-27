import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/app_snakebar.dart';
import '../../../../listing/listing_form/views/widgets/attachment_selection/cept_group_invite_usecase.dart';
import '../../../chat_dashboard/data/sources/local/local_chat.dart';
import '../../../chat_dashboard/domain/entities/chat/chat_entity.dart';
import '../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../chat_dashboard/domain/usecase/get_my_chats_usecase.dart';
import '../../data/models/message_last_evaluated_key.dart';
import '../../domain/entities/getted_message_entity.dart';
import '../../domain/entities/message_last_evaluated_key_entity.dart';
import '../../domain/params/leave_group_params.dart';
import '../../domain/params/send_invite_to_group_params.dart';
import '../../domain/usecase/get_messages_usecase.dart';
import '../../domain/usecase/leave_group_usecase.dart';
import '../../domain/usecase/send_group_invite_usecase.dart';
import '../screens/chat_screen.dart';

class ChatProvider extends ChangeNotifier {
  ChatProvider(
    this._getMessagesUsecase,
    this._acceptGroupInviteUsecase,
    this._leaveGroupparams,
    this._sendGroupInviteUsecase,
    this._getmychatusecase,
  );
  final GetMessagesUsecase _getMessagesUsecase;
  final AcceptGorupInviteUsecase _acceptGroupInviteUsecase;
  final LeaveGroupUsecase _leaveGroupparams;
  final SendGroupInviteUsecase _sendGroupInviteUsecase;
  final GetMyChatsUsecase _getmychatusecase;
  ChatEntity? _chat;
  MessageLastEvaluatedKeyEntity? _key;
  GettedMessageEntity? _gettedMessage;
  DateTime? _chatAt;
  bool _isLoading = false;

//

  GettedMessageEntity? get gettedMessage => _gettedMessage;
  DateTime? get chatAT => _chatAt;
  ChatEntity? get chat => _chat;
//
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

//
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

  Future<void> createOrOpenChatById(BuildContext context, String chatId) async {
    final DataState<List<ChatEntity>> chatResult =
        await _getmychatusecase.call(<String>[chatId]);

    if (chatResult is DataSuccess && (chatResult.data?.isNotEmpty ?? false)) {
      final ChatEntity chat = chatResult.entity!.first;
      await openChat(context, chat);
    } else if (chatResult is DataFailer) {
      AppLog.error(
        chatResult.exception?.message ??
            'ERROR - BookingProvider.createOrOpenChatById',
        name: 'BookingProvider.createOrOpenChatById - failed',
        error: chatResult.exception,
      );
    }
  }

  Future<void> openChat(BuildContext context, ChatEntity chat) async {
    setChat(chat);
    getMessages();
    Navigator.of(context).pushNamed(ChatScreen.routeName);
  }

  Future<bool> loadMessages() async {
    if (_gettedMessage?.lastEvaluatedKey?.paginationKey == null || _isLoading) {
      return true;
    }
    return await getMessages();
  }

//

  Future<void> acceptGroupInvite(BuildContext context) async {
    setLoading(true);
    final DataState<bool> result =
        await _acceptGroupInviteUsecase.call(chat?.chatId ?? '');
    try {
      if (result is DataSuccess) {
        setChat(LocalChat().chatEntity(chat?.chatId ?? ''));
        debugPrint('provider chat is updated');
        setLoading(false);
      } else {
        AppSnackBar.showSnackBar(
          context,
          result.exception?.message ?? 'something_wrong'.tr(),
        );
        setLoading(false);
        AppLog.error('you accepted group invite',
            name: 'ChatPRovider.LeaveGroup - else');
      }
    } catch (e, stc) {
      AppLog.error('failed to accept invite',
          name: 'ChatPRovider.LeaveGroup - else', error: e, stackTrace: stc);
      setLoading(false);
    }
  }

  Future<void> leaveGroup() async {
    setLoading(true);
    LeaveGroupParams leaveparams =
        LeaveGroupParams(chatId: chat?.chatId ?? '', removalType: 'leave');
    final DataState<bool> result = await _leaveGroupparams.call(leaveparams);
    try {
      if (result is DataSuccess) {
        setChat(LocalChat().chatEntity(chat?.chatId ?? ''));
        debugPrint('you left the group${leaveparams.chatId}');
        setLoading(false);
      } else {
        AppLog.error('you failed to leave the group${leaveparams.chatId}',
            name: 'ChatPRovider.LeaveGroup - else');
        setLoading(false);
      }
    } catch (e, stc) {
      AppLog.error('error chatprovider - LeaveGroup',
          name: 'ChatPRovider.LeaveGroup - Catch', error: e, stackTrace: stc);
      setLoading(false);
    }
  }

  Future<void> removeFromGroup(String? partcicpantId) async {
    setLoading(true);
    LeaveGroupParams leaveparams = LeaveGroupParams(
      participantId: partcicpantId,
      chatId: chat?.chatId ?? '',
      removalType: 'remove',
    );
    final DataState<bool> result = await _leaveGroupparams.call(leaveparams);
    try {
      if (result is DataSuccess) {
        setChat(LocalChat().chatEntity(chat?.chatId ?? ''));
        debugPrint(
            'you removed ${leaveparams.participantId} from group${leaveparams.chatId}');
        setLoading(false);
      } else {
        AppLog.error(
            'you failed to remove ${leaveparams.participantId} from group${leaveparams.chatId}',
            name: 'ChatPRovider.LeaveGroup - else');
        setLoading(false);
      }
    } catch (e, stc) {
      AppLog.error('error chatprovider - LeaveGroup',
          name: 'ChatPRovider.LeaveGroup - Catch', error: e, stackTrace: stc);
      setLoading(false);
    }
  }

  Future<void> sendGroupInvite(List<String> newParticipant) async {
    setLoading(true);
    SendGroupInviteParams inviteparams = SendGroupInviteParams(
        chatId: chat?.chatId ?? '', newParticipants: newParticipant);
    final DataState<bool> result =
        await _sendGroupInviteUsecase.call(inviteparams);
    try {
      if (result is DataSuccess) {
        debugPrint(
            'you invited${inviteparams.newParticipants} to ${inviteparams.chatId}');
        setLoading(false);
      } else {
        AppLog.error('you failed to invite to the group${inviteparams.chatId}',
            name: 'ChatPRovider.sendGroupInvite - else');
        setLoading(false);
      }
    } catch (e, stc) {
      AppLog.error('error chatprovider - sendGroupInvite',
          name: 'ChatPRovider.sendGroupInvite - Catch',
          error: e,
          stackTrace: stc);
      setLoading(false);
    }
  }
}
