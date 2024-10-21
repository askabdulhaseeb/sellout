import '../../../../../../core/sources/data_state.dart';
import '../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../entities/getted_message_entity.dart';

abstract interface class MessageRepository {
  Future<DataState<GettedMessageEntity>> getMessages({
    required String chatID,
    required String? key,
    required String createdAt,
  });
  Future<void> sendMessage(MessageEntity msg);
}
