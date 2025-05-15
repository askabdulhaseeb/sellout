import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../../attachment/domain/entities/picked_attachment_option.dart';
import '../../../../../attachment/views/screens/pickable_attachment_screen.dart';
import '../../../chat_dashboard/domain/entities/chat/chat_entity.dart';
import '../../../chat_dashboard/domain/entities/chat/participant/chat_participant_entity.dart';
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

  int getUnreadMessageCount(String userId) {
    if (_chat == null ||
        _chat!.participants == null ||
        _gettedMessage == null) {
      return 0;
    }

    // Find the participant for the user
    final ChatParticipantEntity participant = _chat!.participants!.firstWhere(
      (ChatParticipantEntity p) => p.uid == userId,
    );

    final DateTime lastReadAt = participant.chatAt;

    // Count messages with createdAt > lastReadAt
    final int unreadCount =
        _gettedMessage!.messages.where((MessageEntity message) {
      return message.createdAt.isAfter(lastReadAt);
    }).length;

    return unreadCount;
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

  Future<void> sendMessage(BuildContext context) async {
    final SendMessageParam param = SendMessageParam(
      chatID: _chat?.chatId ?? _key?.chatID ?? '',
      text: _message.text,
      persons: _chat?.persons ?? <String>[],
      files: <PickedAttachment>[],
      source: 'application',
    );
    final DataState<bool> result = await _sendMessageUsecase(param);
    if (result is DataSuccess) {
      _message.clear();
    } else {
      AppSnackBar.showSnackBar(
          // ignore: use_build_context_synchronously
          context,
          result.exception?.message ?? 'something_wrong'.tr());
    }
  }
}
