import '../../../../../../core/sources/data_state.dart';
import '../entities/chat/chat_entity.dart';
import '../params/create_chat_params.dart';

abstract interface class ChatRepository {
  Future<DataState<List<ChatEntity>>> call(List<String>? params);
  Future<DataState<ChatEntity>> createChat(
      CreateChatParams params);
}
