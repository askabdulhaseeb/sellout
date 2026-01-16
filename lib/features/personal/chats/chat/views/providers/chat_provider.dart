import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sockets/socket_service.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../services/get_it.dart';
import '../../../../../business/core/data/sources/local_business.dart';
import '../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../listing/listing_form/views/widgets/attachment_selection/cept_group_invite_usecase.dart';
import '../../../../user/profiles/data/sources/local/local_user.dart';
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

  /// Cache for sender display names to avoid repeated async lookups
  final Map<String, String> _senderNameCache = <String, String>{};

  // ============ Read Receipt State ============
  Timer? _readReceiptDebounceTimer;
  String? _lastReadMessageId;
  static const Duration _readReceiptDebounceDelay = Duration(milliseconds: 500);

//

  GettedMessageEntity? get gettedMessage => _gettedMessage;
  DateTime? get chatAT => _chatAt;
  ChatEntity? get chat => _chat;
  bool get isLoading => _isLoading;
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
    clearSenderNameCache();
    clearReadReceiptState();
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

  /// Gets sender display name from cache, or returns null if not cached.
  /// Use [prefetchSenderNames] to populate the cache first.
  String? getSenderName(String senderId) => _senderNameCache[senderId];

  /// Prefetches sender names for all messages to avoid N+1 async lookups.
  /// Should be called after messages are loaded.
  Future<void> prefetchSenderNames(List<MessageEntity> messages) async {
    final Set<String> uniqueSenderIds = <String>{};
    for (final MessageEntity message in messages) {
      if (!_senderNameCache.containsKey(message.sendBy)) {
        uniqueSenderIds.add(message.sendBy);
      }
    }

    if (uniqueSenderIds.isEmpty) return;

    final List<Future<void>> futures = <Future<void>>[];
    for (final String senderId in uniqueSenderIds) {
      futures.add(_fetchAndCacheSenderName(senderId));
    }
    await Future.wait(futures);
  }

  Future<void> _fetchAndCacheSenderName(String senderId) async {
    if (_senderNameCache.containsKey(senderId)) return;

    final bool isBusiness = senderId.startsWith('BU');
    String? displayName;

    if (isBusiness) {
      final BusinessEntity? business = await LocalBusiness().getBusiness(senderId);
      displayName = business?.displayName;
    } else {
      final UserEntity? user = await LocalUser().user(senderId);
      displayName = user?.displayName;
    }

    _senderNameCache[senderId] = displayName ?? 'na'.tr();
  }

  /// Clears the sender name cache. Called when switching chats.
  void clearSenderNameCache() {
    _senderNameCache.clear();
  }

  // ============ Read Receipt Methods ============

  /// Marks messages as read with debouncing to batch multiple reads.
  /// Call this when messages become visible in the chat view.
  void markMessagesAsRead(List<MessageEntity> visibleMessages) {
    final String? chatId = _chat?.chatId;
    final String? currentUserId = LocalAuth.uid;
    if (chatId == null || currentUserId == null) return;

    // Filter messages not sent by current user
    final List<MessageEntity> unreadMessages = visibleMessages
        .where((MessageEntity m) => m.sendBy != currentUserId)
        .toList();

    if (unreadMessages.isEmpty) return;

    // Find the latest message ID
    unreadMessages.sort((MessageEntity a, MessageEntity b) =>
        b.createdAt.compareTo(a.createdAt));
    final String latestMessageId = unreadMessages.first.messageId;

    // Don't re-emit if we already marked this message as read
    if (_lastReadMessageId == latestMessageId) return;

    // Debounce the read receipt emission
    _readReceiptDebounceTimer?.cancel();
    _readReceiptDebounceTimer = Timer(_readReceiptDebounceDelay, () {
      _emitReadReceipt(chatId, latestMessageId);
    });
  }

  /// Marks a single message as read immediately.
  void markSingleMessageAsRead(MessageEntity message) {
    final String? chatId = _chat?.chatId;
    final String? currentUserId = LocalAuth.uid;
    if (chatId == null || currentUserId == null) return;

    // Don't mark own messages as read
    if (message.sendBy == currentUserId) return;

    // Don't re-emit if we already marked this message as read
    if (_lastReadMessageId == message.messageId) return;

    _emitReadReceipt(chatId, message.messageId);
  }

  void _emitReadReceipt(String chatId, String lastReadMessageId) {
    _lastReadMessageId = lastReadMessageId;

    final SocketService socketService = locator<SocketService>();
    socketService.emit('markRead', <String, dynamic>{
      'chat_id': chatId,
      'user_id': LocalAuth.uid,
      'last_read_message_id': lastReadMessageId,
    });

    AppLog.info(
      'Emitted markRead | chatId: $chatId | lastReadMessageId: $lastReadMessageId',
      name: 'ChatProvider',
    );
  }

  /// Clears read receipt state when switching chats.
  void clearReadReceiptState() {
    _readReceiptDebounceTimer?.cancel();
    _lastReadMessageId = null;
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
