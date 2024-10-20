import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../../../core/utilities/app_string.dart';
import '../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../domain/entities/getted_message_entity.dart';

// getOnlineUsers
//
class LocalChatMessage {
  static final String boxTitle = AppStrings.localChatMessagesBox;
  static Box<GettedMessageEntity> get _box =>
      Hive.box<GettedMessageEntity>(boxTitle);
  static Box<GettedMessageEntity> get boxLive => _box;

  static Future<Box<GettedMessageEntity>> get openBox async =>
      await Hive.openBox<GettedMessageEntity>(boxTitle);

  Future<Box<GettedMessageEntity>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    if (isOpen) {
      return _box;
    } else {
      return await Hive.openBox<GettedMessageEntity>(boxTitle);
    }
  }

  Future<void> save(GettedMessageEntity value) async {
    final String id = value.lastEvaluatedKey.chatID;
    final GettedMessageEntity? result = entity(id);
    if (result == null) {
      await _put(id, value);
      return;
    } else {
      final List<MessageEntity> old = result.messages;
      final List<MessageEntity> neww = value.messages;
      if (old.length != neww.length) {
        for (MessageEntity element in neww) {
          if (old.any((MessageEntity e) => e.messageId == element.messageId)) {
            continue;
          } else {
            old.add(element);
          }
        }
      }
      final GettedMessageEntity newGettedMessage = GettedMessageEntity(
        messages: old,
        lastEvaluatedKey: value.lastEvaluatedKey,
      );
      await _put(id, newGettedMessage);
    }
  }

  Future<void> _put(String key, GettedMessageEntity value) async {
    await _box.put(key, value);
  }

  GettedMessageEntity? entity(String value) => _box.get(value);

  List<MessageEntity> messages(String value) {
    final List<GettedMessageEntity> getted = _box.values
        .where((GettedMessageEntity element) =>
            element.lastEvaluatedKey.chatID == value)
        .toList();
    if (getted.isEmpty) return <MessageEntity>[];
    final List<MessageEntity> msgs = getted[0].messages;
    msgs.sort((MessageEntity a, MessageEntity b) =>
        a.createdAt.compareTo(b.createdAt));
    return msgs;
  }
}
