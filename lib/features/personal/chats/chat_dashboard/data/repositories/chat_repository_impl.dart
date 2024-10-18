import '../../../../../../core/sources/data_state.dart';
import '../../domain/entities/chat/chat_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../sources/remote/chat_remote_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({required this.remoteSource});
  final ChatRemoteSource remoteSource;

  @override
  Future<DataState<List<ChatEntity>>> call(List<String>? params) async {
    return await remoteSource.getChats(params);
  }
}
