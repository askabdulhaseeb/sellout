import '../../../../../core/usecase/usecase.dart';
import '../../data/services/appointment_api.dart';

class ReleasePaymentUsecase implements UseCase<bool, String> {
  const ReleasePaymentUsecase(this.repository);
  final AppointmentApi repository;

  @override
  Future<DataState<bool>> call(String transactionId) async {
    return await repository.releasePayment(transactionId);
  }
}
