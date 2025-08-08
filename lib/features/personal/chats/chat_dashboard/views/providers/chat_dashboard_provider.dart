import 'dart:developer';
import 'package:flutter/cupertino.dart';
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

  List<ChatEntity> _filteredChats = <ChatEntity>[]; // 🔍 Filtered list
  List<ChatEntity> get filteredChats => _filteredChats;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  TextEditingController searchController = TextEditingController();
  Future<DataState<List<ChatEntity>>> getChats() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final DataState<List<ChatEntity>> result =
        await _getMyChatsUsecase.call(null);
    if (result is DataSuccess) {
      _chats = result.entity ?? <ChatEntity>[];
      _filteredChats = _chats; // 📌 By default, show all
      notifyListeners();
    } else {
      log(result.exception?.message ?? 'something went wrong');
    }
    return result;
  }

  // void updateSearchQuery() {
  //   if (searchController.text.isEmpty) {
  //     _filteredChats = _chats;
  //   } else {
  //     _filteredChats = _chats.where((ChatEntity chat) {
  //       // 🧠 Different search logic for groups vs orders
  //       if (_page == ChatPageType.groups) {
  //         final String title = chat.groupInfo?.title ?? '';
  //         return title
  //             .toLowerCase()
  //             .contains(searchController.text.toLowerCase());
  //       } else {
  //         final String title = '';
  //         return title
  //             .toLowerCase()
  //             .contains(searchController.text.toLowerCase());
  //       }
  //     }).toList();
  //   }

  //   notifyListeners();
  // }

  // 🔁 Tab Controller
  ChatPageType _page = ChatPageType.orders;
  ChatPageType get currentPage => _page;

  void setCurrentTabIndex(ChatPageType value) {
    _page = value;
    notifyListeners();
  }
}
