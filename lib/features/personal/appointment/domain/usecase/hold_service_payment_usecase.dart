import '../../../../../core/usecase/usecase.dart';
import '../../../../../features/personal/appointment/data/model/hold_service_payment_model.dart';
import '../../../../../features/personal/appointment/domain/params/hold_service_params.dart';
import '../../../../../features/personal/appointment/domain/repository/appointment_repository.dart';

class HoldServicePaymentUsecase
    implements UseCase<HoldServiceResponse, HoldServiceParams> {
  const HoldServicePaymentUsecase(this._repository);
  final AppointmentRepository _repository;

  @override
  Future<DataState<HoldServiceResponse>> call(HoldServiceParams param) async =>
      await _repository.holdServicePayment(param);
}
