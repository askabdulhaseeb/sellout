import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../../attachment/domain/entities/picked_attachment_option.dart';
import '../../../../../attachment/views/screens/pickable_attachment_screen.dart';
import '../../../../search/domain/entities/search_entity.dart';
import '../../../../search/domain/enums/search_entity_type.dart';
import '../../../../search/domain/params/search_enum.dart';
import '../../../../search/domain/usecase/search_usecase.dart';
import '../../../../user/profiles/data/models/user_model.dart';
import '../../../chat_dashboard/data/models/chat/chat_model.dart';
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
        result.exception?.message ?? 'something_wrong'.tr(),
      );
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
}
