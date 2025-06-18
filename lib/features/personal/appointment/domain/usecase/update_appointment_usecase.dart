import '../../../../../core/usecase/usecase.dart';
import '../params/update_appointment_params.dart';
import '../repository/appointment_repository.dart';

class UpdateAppointmentUsecase
    implements UseCase<bool, UpdateAppointmentParams> {
  const UpdateAppointmentUsecase(this._repository);
  final AppointmentRepository _repository;

  @override
  Future<DataState<bool>> call(UpdateAppointmentParams param) async =>
      await _repository.updateAppointment(param);
}
