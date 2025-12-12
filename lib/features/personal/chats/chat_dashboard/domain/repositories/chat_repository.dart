import '../../../../../../core/sources/data_state.dart';
import '../../../chat/domain/params/post_inquiry_params.dart';
import '../entities/chat/chat_entity.dart';
import '../params/create_chat_params.dart';

abstract interface class ChatRepository {
  Future<DataState<List<ChatEntity>>> getchats(List<String>? params);
  Future<DataState<ChatEntity>> createChat(CreateChatParams params);
  Future<DataState<ChatEntity>> createInquiryChat(PostInquiryParams params);
}
