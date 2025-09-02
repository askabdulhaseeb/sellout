import '../../../../../core/sources/data_state.dart';
import '../../data/model/hold_service_payment_model.dart';
import '../params/hold_service_params.dart';
import '../params/update_appointment_params.dart';

abstract interface class AppointmentRepository {
  Future<DataState<bool>> updateAppointment(UpdateAppointmentParams param);
  Future<DataState<HoldServiceResponse>> holdServicePayment(
    HoldServiceParams params,
  );
}
