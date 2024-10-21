import '../../../../../../core/usecase/usecase.dart';
import '../entities/getted_message_entity.dart';
import '../entities/message_last_evaluated_key_entity.dart';
import '../repositories/message_reposity.dart';

class GetMessagesUsecase
    implements UseCase<GettedMessageEntity, MessageLastEvaluatedKeyEntity> {
  GetMessagesUsecase(this.repository);
  final MessageRepository repository;

  @override
  Future<DataState<GettedMessageEntity>> call(
      MessageLastEvaluatedKeyEntity params) async {
    return await repository.getMessages(
      chatID: params.chatID,
      key: params.paginationKey,
      createdAt: params.createdAt,
    );
  }
}
