import '../../../../../../core/sources/data_state.dart';
import '../../domain/entities/getted_message_entity.dart';
import '../../domain/params/send_message_param.dart';
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
  Future<DataState<bool>> sendMessage(SendMessageParam msg) async {
    return await remoteSource.sendMessage(msg);
  }

  @override
  Future<DataState<bool>> acceptGorupInvite(String groupId)async{
    return await remoteSource.acceptGorupInvite(groupId);
    }
}
