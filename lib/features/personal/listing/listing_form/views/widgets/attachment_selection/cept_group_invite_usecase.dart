
import '../../../../../../../core/usecase/usecase.dart';
import '../../../../../chats/chat/domain/repositories/message_reposity.dart';

class AcceptGorupInviteUsecase implements UseCase<bool, String> {
  const AcceptGorupInviteUsecase(this.repository);
  final MessageRepository repository;
  @override
  Future<DataState<bool>> call(String params) async {
    return await repository.acceptGorupInvite(params);
  }
}