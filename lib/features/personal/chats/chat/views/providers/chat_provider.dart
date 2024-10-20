import 'package:flutter/material.dart';

import '../../../chat_dashboard/domain/entities/chat/chat_entity.dart';

class ChatProvider extends ChangeNotifier {
  ChatEntity? _chat;
  ChatEntity? get chat => _chat;

  set chat(ChatEntity? value) {
    _chat = value;
    notifyListeners();
  }

  Future<void> getMessages() async {}
}
