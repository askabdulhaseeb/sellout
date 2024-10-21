import 'package:hive/hive.dart';

import '../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import 'message_last_evaluated_key_entity.dart';

part 'getted_message_entity.g.dart';

@HiveType(typeId: 33)
class GettedMessageEntity {
  const GettedMessageEntity({
    required this.chatID,
    required this.messages,
    required this.lastEvaluatedKey,
  });

  @HiveField(0)
  final List<MessageEntity> messages;
  @HiveField(1)
  final MessageLastEvaluatedKeyEntity? lastEvaluatedKey;
  @HiveField(2)
  final String chatID;

  List<MessageEntity> sortedMessage() {
    messages.sort((MessageEntity a, MessageEntity b) =>
        b.createdAt.compareTo(a.createdAt));
    return messages;
  }
}
