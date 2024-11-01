import '../../../../../../core/usecase/usecase.dart';
import '../params/send_message_param.dart';
import '../repositories/message_reposity.dart';

class SendMessageUsecase implements UseCase<bool, SendMessageParam> {
  const SendMessageUsecase(this.repository);
  final MessageRepository repository;
  @override
  Future<DataState<bool>> call(SendMessageParam params) async {
    return await repository.sendMessage(params);
  }
}
