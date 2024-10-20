import '../../../../../../core/sources/data_state.dart';
import '../../../chat_dashboard/domain/entities/messages/message_entity.dart';

abstract interface class MessageRepository {
  Future<DataState<List<MessageEntity>>> getMessages({
    required String chatID,
    required String? key,
    required DateTime createdAt,
  });
  Future<void> sendMessage(MessageEntity msg);
}
