import '../../../../../../core/usecase/usecase.dart';
import '../params/leave_group_params.dart';
import '../repositories/message_reposity.dart';

class RemoveParticipantUsecase implements UseCase<bool, LeaveGroupParams> {
  const RemoveParticipantUsecase(this.repository);
  final MessageRepository repository;
  @override
  Future<DataState<bool>> call(LeaveGroupParams params) async {
    return await repository.removeParticipants(params);
  }
}
