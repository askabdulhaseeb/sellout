import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/utilities/app_string.dart';

import '../../models/chat/chat_model.dart';

// getOnlineUsers
//
class LocalChat {
  static final String boxTitle = AppStrings.localChatsBox;
  static Box<ChatEntity> get _box => Hive.box<ChatEntity>(boxTitle);
  static Box<ChatEntity> get boxLive => _box;

  static Future<Box<ChatEntity>> get openBox async =>
      await Hive.openBox<ChatEntity>(boxTitle);

  Future<Box<ChatEntity>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    if (isOpen) {
      return _box;
    } else {
      return await Hive.openBox<ChatEntity>(boxTitle);
    }
  }

  Future<void> save(ChatEntity value) async =>
      await _box.put(value.chatId, value);
  ChatEntity? chatEntity(String value) => _box.get(value);

  DataState<ChatEntity?> chatState(String value) {
    final ChatEntity? entity = _box.get(value);
    if (entity != null) {
      return DataSuccess<ChatEntity?>(value, entity);
    } else {
      return DataFailer<ChatEntity?>(CustomException('Loading...'));
    }
  }
}
