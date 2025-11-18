import '../../../../../../core/usecase/usecase.dart';
import '../entities/chat/chat_entity.dart';
import '../params/create_chat_params.dart';
import '../repositories/chat_repository.dart';

class CreateChatUsecase implements UseCase<ChatEntity, CreateChatParams> {
  const CreateChatUsecase(this.repository);
  final ChatRepository repository;
  @override
  Future<DataState<ChatEntity>> call(CreateChatParams params) async {
    return await repository.createChat(params);
  }
}
