import '../../../../../../core/sources/data_state.dart';
import '../entities/chat/chat_entity.dart';

abstract interface class ChatRepository {
  Future<DataState<List<ChatEntity>>> call(List<String>? params);
}
