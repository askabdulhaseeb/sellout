import '../../../../../core/sources/data_state.dart';
import '../../../../personal/bookings/domain/entity/booking_entity.dart';
import '../entities/services_list_responce_entity.dart';
import '../params/get_business_bookings_params.dart';
import '../params/get_business_serives_param.dart';

abstract interface class BusinessPageRepository {
  Future<DataState<ServicesListResponceEntity>> businessServices(
      GetBusinessSerivesParam param);

  Future<DataState<List<BookingEntity>>> getBookings(
      GetBusinessBookingsParams params);
}
