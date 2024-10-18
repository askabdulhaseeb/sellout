import 'package:flutter/foundation.dart';

import '../../../../../../core/enums/chat/chat_page_type.dart';
export '../../../../../../core/enums/chat/chat_page_type.dart';

class ChatDashboardProvider extends ChangeNotifier {
  ChatPageType _page = ChatPageType.orders;

  ChatPageType get currentPage => _page;

  void setCurrentTabIndex(ChatPageType value) {
    _page = value;
    notifyListeners();
  }
}
