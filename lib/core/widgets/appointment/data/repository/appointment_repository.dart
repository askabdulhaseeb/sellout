import '../../../../sources/data_state.dart';
import '../../domain/params/update_appointment_params.dart';
import '../../domain/repository/appointment_repository.dart';
import '../services/appointment_api.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  const AppointmentRepositoryImpl(this._appointmentApi);
  final AppointmentApi _appointmentApi;

  @override
  Future<DataState<bool>> updateAppointment(UpdateAppointmentParams p) async =>
      await _appointmentApi.updateAppointment(p);
}
