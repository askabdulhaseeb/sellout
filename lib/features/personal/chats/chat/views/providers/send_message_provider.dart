import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/enums/message/message_status.dart';
import '../../../../../../core/enums/message/message_type.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../../attachment/domain/entities/picked_attachment_option.dart';
import '../../../../../attachment/views/screens/pickable_attachment_screen.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../search/domain/entities/search_entity.dart';
import '../../../../search/domain/enums/search_entity_type.dart';
import '../../../../search/domain/params/search_enum.dart';
import '../../../../search/domain/usecase/search_usecase.dart';
import '../../../../user/profiles/data/models/user_model.dart';
import '../../../chat_dashboard/data/models/chat/chat_model.dart';
import '../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../domain/params/send_message_param.dart';
import '../../domain/usecase/send_message_usecase.dart';

class SendMessageProvider extends ChangeNotifier {
  SendMessageProvider(this._sendMessageUsecase, this._searchUsecase);
  final SendMessageUsecase _sendMessageUsecase;
  final SearchUsecase _searchUsecase;

  static const String tag = 'SendMessageProvider';

  //varibales
  bool _isLoading = false;
  ChatEntity? _chat;
  final ValueNotifier<bool> isRecordingAudio = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isAttachmentMenuOpen = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isEmojiPickerOpen = ValueNotifier<bool>(false);
  final TextEditingController _message = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();
  final List<PickedAttachment> _attachments = <PickedAttachment>[];
  final List<PickedAttachment> _document = <PickedAttachment>[];
  final List<PickedAttachment> _contact = <PickedAttachment>[];
  final List<PickedAttachment> _voiceNote = <PickedAttachment>[];
  final List<UserEntity> _users = <UserEntity>[];
  String? _lastUserKey;
  bool _hasMoreUsers = true;
  bool _isUserLoading = false;
  TextSelection lastSelection = const TextSelection.collapsed(offset: 0);

  /// Pending messages being sent (optimistic UI)
  final ValueNotifier<List<MessageEntity>> pendingMessages =
      ValueNotifier<List<MessageEntity>>(<MessageEntity>[]);

  /// Timers that delay marking a pending message as failed.
  /// Keyed by temporary message id.
  final Map<String, Timer> _failureTimers = <String, Timer>{};

  //getters
  bool get isLoading => _isLoading;
  ChatEntity? get chat => _chat;
  List<PickedAttachment> get attachments => _attachments;
  List<PickedAttachment> get document => _document;
  List<PickedAttachment> get contact => _contact;
  List<PickedAttachment> get voiceNote => _voiceNote;
  List<UserEntity> get users => _users;
  bool get hasMoreUsers => _hasMoreUsers;
  bool get isUserLoading => _isUserLoading;

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
    AppLog.info('startRecording()', name: tag);
    isRecordingAudio.value = true;
    notifyListeners();
  }

  void stopRecording() {
    AppLog.info('stopRecording()', name: tag);
    isRecordingAudio.value = false;
    notifyListeners();
  }

  /// Opens attachment menu and closes emoji picker if open
  void openAttachmentMenu() {
    if (isEmojiPickerOpen.value) {
      isEmojiPickerOpen.value = false;
    }
    isAttachmentMenuOpen.value = true;
  }

  /// Closes attachment menu
  void closeAttachmentMenu() {
    isAttachmentMenuOpen.value = false;
  }

  /// Opens emoji picker, closes attachment menu, and dismisses keyboard
  void openEmojiPicker() {
    if (isAttachmentMenuOpen.value) {
      isAttachmentMenuOpen.value = false;
    }
    // Unfocus to dismiss keyboard
    messageFocusNode.unfocus();
    isEmojiPickerOpen.value = true;
  }

  /// Closes emoji picker and optionally focuses the text field
  void closeEmojiPicker({bool focusTextField = false}) {
    isEmojiPickerOpen.value = false;
    if (focusTextField) {
      messageFocusNode.requestFocus();
    }
  }

  /// Called when text field gains focus - closes emoji picker
  void onTextFieldFocused() {
    if (isEmojiPickerOpen.value) {
      isEmojiPickerOpen.value = false;
    }
  }

  /// Closes both menus
  void closeAllMenus() {
    isAttachmentMenuOpen.value = false;
    isEmojiPickerOpen.value = false;
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
    final List<PickedAttachment> selectedMedia = _attachments.where((
      PickedAttachment element,
    ) {
      return element.selectedMedia != null;
    }).toList();
    final List<PickedAttachment>? files = await Navigator.of(context)
        .push<List<PickedAttachment>>(
          MaterialPageRoute<List<PickedAttachment>>(
            builder: (_) {
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
            },
          ),
        );
    if (files != null) {
      for (final PickedAttachment file in files) {
        final int index = _attachments.indexWhere(
          (PickedAttachment element) =>
              element.selectedMedia == file.selectedMedia,
        );
        if (index == -1) {
          _attachments.add(file);
        }
      }
      notifyListeners();
    }
  }

  Future<void> searchUsers(String query) async {
    if (_isUserLoading) return;
    _isUserLoading = true;
    notifyListeners();

    final DataState<SearchEntity> result = await _searchUsecase.call(
      SearchParams(
        entityType: SearchEntityType.users,
        query: query,
        lastEvaluatedKey: '',
        pageSize: 15,
      ),
    );

    if (result is DataSuccess<SearchEntity>) {
      _users.clear();
      _users.addAll(result.entity?.users ?? <UserEntity>[]);
      _lastUserKey = result.entity?.lastEvaluatedKey;
      _hasMoreUsers = (_users.length >= 15); // or check lastEvaluatedKey
    } else {
      _users.clear();
      _hasMoreUsers = false;
    }

    _isUserLoading = false;
    notifyListeners();
  }

  // Load more users
  Future<void> loadMoreUsers(String query) async {
    if (!_hasMoreUsers || _isUserLoading) return;

    _isUserLoading = true;
    notifyListeners();

    final DataState<SearchEntity> result = await _searchUsecase.call(
      SearchParams(
        entityType: SearchEntityType.users,
        query: query,
        lastEvaluatedKey: _lastUserKey ?? '',
        pageSize: 15,
      ),
    );

    if (result is DataSuccess<SearchEntity>) {
      final List<UserEntity> newUsers = result.entity?.users ?? <UserEntity>[];
      _users.addAll(newUsers);
      _lastUserKey = result.entity?.lastEvaluatedKey;
      _hasMoreUsers = (newUsers.length >= 15); // stop if less than pageSize
    } else {
      _hasMoreUsers = false;
    }

    _isUserLoading = false;
    notifyListeners();
  }

  void resetUserSearch() {
    _users.clear();
    _lastUserKey = null;
    _hasMoreUsers = true;
    notifyListeners();
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

  void addVoiceNote(PickedAttachment attachment) {
    AppLog.info(
      'addVoiceNote(): before clear len=${_voiceNote.length} type=${attachment.type} file=${attachment.file.path}',
      name: tag,
    );
    _voiceNote
      ..clear()
      ..add(attachment);
    AppLog.info(
      'addVoiceNote(): after add len=${_voiceNote.length}',
      name: tag,
    );
    notifyListeners();
  }

  Future<void> sendMessage(BuildContext context) async {
    final String messageText = _message.text;
    final String chatId = _chat?.chatId ?? '';
    final List<String> persons = _chat?.persons ?? <String>[];

    // Don't send empty messages
    if (messageText.isEmpty && _attachments.isEmpty) return;

    // Create a temporary message ID for tracking
    final String tempMessageId = DateTime.now().millisecondsSinceEpoch
        .toString();

    // Create optimistic message entity with pending status
    final MessageEntity pendingMessage = MessageEntity(
      messageId: tempMessageId,
      chatId: chatId,
      text: messageText.isEmpty ? '' : messageText,
      displayText: messageText.isEmpty ? '' : messageText,
      sendBy: LocalAuth.uid ?? '',
      persons: persons,
      fileUrl: <AttachmentEntity>[],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      type: MessageType.text,
      status: MessageStatus.pending,
    );

    // Add to pending messages for immediate UI display
    pendingMessages.value = <MessageEntity>[
      ...pendingMessages.value,
      pendingMessage,
    ];

    // Clear input immediately for better UX
    _message.clear();
    final List<PickedAttachment> attachmentsToSend =
        List<PickedAttachment>.from(_attachments);
    _attachments.clear();
    notifyListeners();

    // Now send to server
    final SendMessageParam param = SendMessageParam(
      chatID: chatId,
      text: messageText.isEmpty ? 'null' : messageText,
      persons: persons,
      files: attachmentsToSend,
      source: 'application',
    );

    final DataState<bool> result = await _sendMessageUsecase(param);

    if (result is DataSuccess) {
      // Remove from pending messages (server will add the real message via socket/local)
      _removePendingMessage(tempMessageId);
      AppLog.info('Message sent successfully', name: tag);
    } else {
      // Don't mark failed immediately. Keep as pending and schedule failure
      // after a grace period (2 minutes) so the UI shows "sending".
      _scheduleFailureTimeout(tempMessageId, result.exception?.message);
      AppLog.info('Message send delayed failure handling scheduled', name: tag);
    }
  }

  /// Removes a pending message by its temporary ID
  void _removePendingMessage(String tempMessageId) {
    pendingMessages.value = pendingMessages.value
        .where((MessageEntity m) => m.messageId != tempMessageId)
        .toList();
    // Cancel any failure timer
    _failureTimers.remove(tempMessageId)?.cancel();
  }

  /// Updates a pending message's status (e.g., to failed)
  void _updatePendingMessageStatus(String tempMessageId, MessageStatus status) {
    pendingMessages.value = pendingMessages.value.map((MessageEntity m) {
      if (m.messageId == tempMessageId) {
        return m.copyWith(status: status);
      }
      return m;
    }).toList();
    if (status == MessageStatus.failed) {
      // Cancel timer when marking failed
      _failureTimers.remove(tempMessageId)?.cancel();
    }
  }

  void _scheduleFailureTimeout(String tempMessageId, String? errorMessage) {
    // Cancel existing timer if any
    _failureTimers.remove(tempMessageId)?.cancel();
    // Schedule marking message as failed after 2 minutes
    final Timer timer = Timer(const Duration(minutes: 2), () {
      _updatePendingMessageStatus(tempMessageId, MessageStatus.failed);
      // Optionally show a snackbar notifying user of failure
      if (errorMessage != null && errorMessage.isNotEmpty) {
        AppLog.info(
          'Message marked failed: $tempMessageId error=$errorMessage',
          name: tag,
        );
      }
      _failureTimers.remove(tempMessageId);
    });
    _failureTimers[tempMessageId] = timer;
  }

  /// Retry sending a failed message
  Future<void> retryMessage(
    BuildContext context,
    MessageEntity failedMessage,
  ) async {
    // Update status to pending
    // Cancel any previous failure timer and mark pending
    _failureTimers.remove(failedMessage.messageId)?.cancel();
    _updatePendingMessageStatus(failedMessage.messageId, MessageStatus.pending);

    // Retry sending
    final SendMessageParam param = SendMessageParam(
      chatID: failedMessage.chatId,
      text: failedMessage.text.isEmpty ? 'null' : failedMessage.text,
      persons: failedMessage.persons,
      files: <PickedAttachment>[],
      source: 'application',
    );

    final DataState<bool> result = await _sendMessageUsecase(param);

    if (result is DataSuccess) {
      _removePendingMessage(failedMessage.messageId);
      AppLog.info('Message retry successful', name: tag);
    } else {
      // Keep as pending and schedule failure after timeout again
      _scheduleFailureTimeout(
        failedMessage.messageId,
        result.exception?.message,
      );
      AppSnackBar.showSnackBar(
        // ignore: use_build_context_synchronously
        context,
        result.exception?.message ?? 'something_wrong'.tr(),
      );
    }
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
        result.exception?.message ?? 'something_wrong'.tr(),
      );
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
      Navigator.pop(context);
    } else {
      AppSnackBar.showSnackBar(
        // ignore: use_build_context_synchronously
        context,
        result.exception?.message ?? 'something_wrong'.tr(),
      );
    }
    setLoading(false);
  }

  Future<void> sendVoiceNote(BuildContext context) async {
    AppLog.info(
      'sendVoiceNote(): begin chatId=${_chat?.chatId} persons=${_chat?.persons.length ?? 0} files=${_voiceNote.length}',
      name: tag,
    );
    setLoading(true);
    final SendMessageParam param = SendMessageParam(
      chatID: _chat?.chatId ?? '',
      text: 'null',
      persons: _chat?.persons ?? <String>[],
      files: _voiceNote,
      source: 'application',
    );
    DataState<bool> result;
    try {
      result = await _sendMessageUsecase(param);
    } catch (e, st) {
      AppLog.error(
        'sendVoiceNote(): usecase THREW',
        name: tag,
        error: e,
        stackTrace: st,
      );
      setLoading(false);
      return;
    }
    if (result is DataSuccess) {
      AppLog.info('sendVoiceNote(): success', name: tag);
      _voiceNote.clear();
      setLoading(false);
    } else {
      AppLog.info(
        'sendVoiceNote(): failure type=${result.runtimeType} message=${result.exception?.message}',
        name: tag,
      );
      AppSnackBar.showSnackBar(
        // ignore: use_build_context_synchronously
        context,
        result.exception?.message ?? 'something_wrong'.tr(),
      );
    }
    setLoading(false);
    AppLog.info(
      'sendVoiceNote(): end (voiceNoteLen=${_voiceNote.length})',
      name: tag,
    );
  }

  @override
  void dispose() {
    // Cancel all pending failure timers to prevent memory leaks
    for (final Timer timer in _failureTimers.values) {
      timer.cancel();
    }
    _failureTimers.clear();
    pendingMessages.dispose();
    isRecordingAudio.dispose();
    isAttachmentMenuOpen.dispose();
    isEmojiPickerOpen.dispose();
    _message.dispose();
    messageFocusNode.dispose();
    super.dispose();
  }
}
