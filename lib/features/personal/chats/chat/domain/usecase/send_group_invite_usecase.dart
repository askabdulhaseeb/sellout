import '../../../../../../core/usecase/usecase.dart';
import '../params/send_invite_to_group_params.dart';
import '../repositories/message_reposity.dart';

class SendGroupInviteUsecase implements UseCase<bool, SendGroupInviteParams> {
  const SendGroupInviteUsecase(this.repository);
  final MessageRepository repository;
  @override
  Future<DataState<bool>> call(SendGroupInviteParams params) async {
    return await repository.sendInviteToGroup(params);
  }
}
