import '../../../../../../core/usecase/usecase.dart';
import '../entities/chat/chat_entity.dart';
import '../params/create_private_chat_params.dart';
import '../repositories/chat_repository.dart';

class CreatePrivateChatUsecase
    implements UseCase<ChatEntity, CreatePrivateChatParams> {
  const CreatePrivateChatUsecase(this.repository);
  final ChatRepository repository;
  @override
  Future<DataState<ChatEntity>> call(CreatePrivateChatParams params) async {
    return await repository.createPrivateChat(params);
  }
}
