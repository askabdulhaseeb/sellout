import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/utilities/app_string.dart';

import '../../models/chat/chat_model.dart';

// getOnlineUsers
//
class LocalChat {
  static final String boxTitle = AppStrings.localChatssBox;
  static Box<ChatModel> get _box => Hive.box<ChatModel>(boxTitle);
  static Box<ChatModel> get boxLive => _box;

  static Future<Box<ChatModel>> get openBox async =>
      await Hive.openBox<ChatModel>(boxTitle);

  Future<Box<ChatModel>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    if (isOpen) {
      return _box;
    } else {
      return await Hive.openBox<ChatModel>(boxTitle);
    }
  }

  Future<void> save(ChatModel value) async =>
      await _box.put(value.chatId, value);
  ChatModel? chatEntity(String value) => _box.get(value);

  DataState<ChatModel?> chatState(String value) {
    final ChatModel? entity = _box.get(value);
    if (entity != null) {
      return DataSuccess<ChatModel?>(value, entity);
    } else {
      return DataFailer<ChatModel?>(CustomException('Loading...'));
    }
  }
}
