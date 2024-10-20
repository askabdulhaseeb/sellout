import 'package:flutter/material.dart';

import '../../../../../../core/sources/data_state.dart';
import '../../../chat_dashboard/domain/entities/chat/chat_entity.dart';
import '../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../data/models/message_last_evaluated_key.dart';
import '../../domain/entities/message_last_evaluated_key_entity.dart';
import '../../domain/usecase/get_messages_usecase.dart';

class ChatProvider extends ChangeNotifier {
  ChatProvider(this._getMessagesUsecase);
  final GetMessagesUsecase _getMessagesUsecase;

  ChatEntity? _chat;
  ChatEntity? get chat => _chat;

  MessageLastEvaluatedKeyEntity? _key;

  set chat(ChatEntity? value) {
    _chat = value;
    _key = MessageLastEvaluatedKeyModel(
      chatID: _chat?.chatId ?? '',
      createdAt: DateTime.now(),
    );
    notifyListeners();
  }

  Future<bool> getMessages() async {
    final DataState<List<MessageEntity>> result =
        await _getMessagesUsecase(_key ??
            MessageLastEvaluatedKeyModel(
              chatID: _chat?.chatId ?? '',
              createdAt: DateTime.now(),
            ));
    if (result is DataSuccess<List<MessageEntity>>) {
      // chat = chat?.copyWith(messages: result.data);
      return true;
    } else {
      // Show error message
      return false;
    }
  }
}
