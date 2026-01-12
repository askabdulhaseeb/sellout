import '../../../../../../core/sources/data_state.dart';
import '../../../chat/domain/params/post_inquiry_params.dart';
import '../../domain/entities/chat/chat_entity.dart';
import '../../domain/params/create_chat_params.dart';
import '../../domain/repositories/chat_repository.dart';
import '../sources/remote/chat_remote_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({required this.remoteSource});
  final ChatRemoteSource remoteSource;

  @override
  Future<DataState<List<ChatEntity>>> getchats(List<String>? params) async {
    return await remoteSource.getChats(params);
  }

  @override
  Future<DataState<ChatEntity>> createChat(CreateChatParams params) async {
    return await remoteSource.createChat(params);
  }

  @override
  Future<DataState<ChatEntity>> createInquiryChat(
    PostInquiryParams params,
  ) async {
    return await remoteSource.createInquiryChat(params);
  }
}
