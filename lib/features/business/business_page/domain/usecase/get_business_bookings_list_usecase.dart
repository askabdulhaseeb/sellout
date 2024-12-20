import '../../../../../core/usecase/usecase.dart';
import '../../../../personal/bookings/domain/entity/booking_entity.dart';
import '../params/get_business_bookings_params.dart';
import '../repositories/business_page_services_repository.dart';

class GetBusinessBookingsListUsecase
    implements UseCase<List<BookingEntity>, GetBusinessBookingsParams> {
  GetBusinessBookingsListUsecase(this._repository);
  final BusinessPageRepository _repository;

  @override
  Future<DataState<List<BookingEntity>>> call(
      GetBusinessBookingsParams params) async {
    return await _repository.getBookings(params);
  }
}
