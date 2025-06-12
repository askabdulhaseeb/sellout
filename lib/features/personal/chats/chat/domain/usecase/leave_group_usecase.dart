import '../../../../../../core/usecase/usecase.dart';
import '../params/leave_group_params.dart';
import '../repositories/message_reposity.dart';

class LeaveGroupUsecase implements UseCase<bool, LeaveGroupParams> {
  const LeaveGroupUsecase(this.repository);
  final MessageRepository repository;
  @override
  Future<DataState<bool>> call(LeaveGroupParams params) async {
    return await repository.removeParticipants(params);
  }
}
