import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../listing/listing_form/views/widgets/attachment_selection/cept_group_invite_usecase.dart';
import '../../../chat_dashboard/data/sources/local/local_chat.dart';
import '../../../chat_dashboard/domain/entities/chat/chat_entity.dart';
import '../../../chat_dashboard/domain/entities/chat/participant/chat_participant_entity.dart';
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
import 'send_message_provider.dart';

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
  bool _expandVisitingMessage = true;
  bool _showPinnedMessage = true;

//

  GettedMessageEntity? get gettedMessage => _gettedMessage;
  DateTime? get chatAT => _chatAt;
  ChatEntity? get chat => _chat;
  bool get expandVisitingMessage => _expandVisitingMessage;
  bool get showPinnedMessage => _showPinnedMessage;
//
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setPinnedMessageVisibility(bool? val) {
    if (val == null) {
      _showPinnedMessage = !_showPinnedMessage;
    } else {
      _showPinnedMessage = val;
    }
    notifyListeners();
  }

  void setPinnedMessageExpandedState() {
    _expandVisitingMessage = !_expandVisitingMessage;
    notifyListeners();
  }

  void resetPinnedMessageExpandedState() {
    _expandVisitingMessage = true;
    notifyListeners();
  }

//
  void setChat(BuildContext context, ChatEntity? value) {
    _chat = value;
    Provider.of<SendMessageProvider>(context, listen: false).setChat(value);
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

  List<MessageEntity> getFilteredMessages(GettedMessageEntity messages) {
    final List<MessageEntity> allMessages = messages.messages;
    if (chat?.type != ChatType.group) return allMessages;

    final DateTime? joinedAt = _getJoinedAt();
    return joinedAt == null
        ? <MessageEntity>[]
        : _filterMessagesAfter(allMessages, joinedAt);
  }

  // Calculate time difference between consecutive messages
  Duration calculateTimeDifference(MessageEntity current, MessageEntity? next) {
    return (next != null && current.sendBy == next.sendBy)
        ? current.createdAt.difference(next.createdAt)
        : const Duration(days: 5);
  }

  // Helper to filter messages after join time
  List<MessageEntity> _filterMessagesAfter(
      List<MessageEntity> messages, DateTime threshold) {
    return messages
        .where((MessageEntity m) => m.createdAt.isAfter(threshold))
        .toList();
  }

  // Get user's join time for groups
  DateTime? _getJoinedAt() {
    final String userId = LocalAuth.uid ?? '';
    final List<ChatParticipantEntity> participants =
        _chat?.groupInfo?.participants ?? <ChatParticipantEntity>[];

    for (final ChatParticipantEntity p in participants) {
      if (p.uid == userId) {
        return p.chatAt;
      }
    }

    // If not a participant, return null
    return null;
  }

  // Static method to compare message lists
  static bool areListsEqual(List<MessageEntity> a, List<MessageEntity> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].messageId != b[i].messageId ||
          a[i].updatedAt != b[i].updatedAt) {
        return false;
      }
    }
    return true;
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
    setChat(context, chat);
    getMessages();
    Navigator.pushReplacementNamed(context, ChatScreen.routeName);
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
        setChat(context, LocalChat().chatEntity(chat?.chatId ?? ''));
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

  Future<void> leaveGroup(BuildContext context) async {
    setLoading(true);
    LeaveGroupParams leaveparams =
        LeaveGroupParams(chatId: chat?.chatId ?? '', removalType: 'leave');
    final DataState<bool> result = await _leaveGroupparams.call(leaveparams);
    try {
      if (result is DataSuccess) {
        setChat(context, LocalChat().chatEntity(chat?.chatId ?? ''));
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

  Future<void> removeFromGroup(
      BuildContext context, String? partcicpantId) async {
    setLoading(true);
    LeaveGroupParams leaveparams = LeaveGroupParams(
      participantId: partcicpantId,
      chatId: chat?.chatId ?? '',
      removalType: 'remove',
    );
    final DataState<bool> result = await _leaveGroupparams.call(leaveparams);
    try {
      if (result is DataSuccess) {
        setChat(context, LocalChat().chatEntity(chat?.chatId ?? ''));
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
