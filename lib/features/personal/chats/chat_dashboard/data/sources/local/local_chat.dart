import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../services/get_it.dart';
import '../../../domain/entities/messages/message_entity.dart';
import '../../../domain/usecase/get_my_chats_usecase.dart';
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

  List<ChatEntity> getAllChats() {
    return _box.values.toList();
  }

  Future<void> save(ChatEntity value) async =>
      await _box.put(value.chatId, value);
  Future<void> clear() async => await _box.clear();
  ChatEntity? chatEntity(String value) => _box.get(value);
  DataState<ChatEntity?> chatState(String value) {
    final ChatEntity? entity = _box.get(value);
    if (entity != null) {
      //entity.lastMessage
      return DataSuccess<ChatEntity?>(value, entity);
    } else {
      return DataFailer<ChatEntity?>(CustomException('Loading...'));
    }
  }

//
  Future<void> updateLastMessage(String chatId, MessageEntity newMsg) async {
    final ChatEntity? existing = _box.get(chatId);
    if (existing == null) {
      // If chat does not exist locally, you might fetch it
      await GetMyChatsUsecase(locator()).call(<String>[chatId]);
    } else {
      // If chat exists, update the lastMessage
      final ChatEntity updated = existing.copyWith(lastMessage: newMsg);
      await _box.put(chatId, updated);
    }
  }

  Future<void> updatePinnedMessage(MessageEntity newMsg) async {
    final ChatEntity? existing = _box.get(newMsg.chatId);
    if (existing == null) {
      // If chat does not exist locally, you might fetch it
      await GetMyChatsUsecase(locator()).call(<String>[newMsg.chatId]);
    } else {
      final ChatEntity updated = existing.copyWith(
        pinnedMessage: newMsg,
      );

      await _box.put(
          newMsg.chatId, updated); // This notifies listeners if UI is listening
    }
  }
}
