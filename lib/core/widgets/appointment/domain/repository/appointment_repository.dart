import '../../../../sources/data_state.dart';
import '../params/update_appointment_params.dart';

abstract interface class AppointmentRepository {
  Future<DataState<bool>> updateAppointment(UpdateAppointmentParams param);
}
