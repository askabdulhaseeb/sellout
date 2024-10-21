import '../../../../../../core/sources/data_state.dart';
import '../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../domain/entities/getted_message_entity.dart';
import '../../domain/repositories/message_reposity.dart';
import '../sources/remote/messages_remote_source.dart';

class MessageRepositoryImpl implements MessageRepository {
  const MessageRepositoryImpl(this.remoteSource);
  final MessagesRemoteSource remoteSource;

  @override
  Future<DataState<GettedMessageEntity>> getMessages({
    required String chatID,
    required String? key,
    required String createdAt,
  }) async {
    return await remoteSource.getMessages(
      chatID: chatID,
      key: key,
      createdAt: createdAt,
    );
  }

  @override
  Future<void> sendMessage(MessageEntity msg) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }
}
