import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../../../../../core/enums/chat/chat_page_type.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../domain/entities/chat/chat_entity.dart';
import '../../domain/usecase/get_my_chats_usecase.dart';
export '../../../../../../core/enums/chat/chat_page_type.dart';

class ChatDashboardProvider extends ChangeNotifier {
  ChatDashboardProvider(this._getMyChatsUsecase);
  final GetMyChatsUsecase _getMyChatsUsecase;

  List<ChatEntity> _chats = <ChatEntity>[];
  List<ChatEntity> get chats => _chats;

  Future<DataState<List<ChatEntity>>> getChats() async {
    final DataState<List<ChatEntity>> result =
        await _getMyChatsUsecase.call(null);
    if (result is DataSuccess) {
      _chats = result.entity ?? <ChatEntity>[];
      notifyListeners();
    } else {
      log(result.exception?.message ?? 'something wrong');
    }
    return result;
  }

  //
  // Page Controller
  ChatPageType _page = ChatPageType.orders;

  ChatPageType get currentPage => _page;

  void setCurrentTabIndex(ChatPageType value) {
    _page = value;
    notifyListeners();
  }
}
