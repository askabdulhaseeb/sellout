import '../../../../../../core/usecase/usecase.dart';
import '../entities/chat/chat_entity.dart';
import '../repositories/chat_repository.dart';

class GetMyChatsUsecase implements UseCase<List<ChatEntity>, List<String>?> {
  GetMyChatsUsecase(this.repository);
  final ChatRepository repository;

  @override
  Future<DataState<List<ChatEntity>>> call(List<String>? params) async {
    return await repository.call(params);
  }
}
