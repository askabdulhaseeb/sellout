import '../../../../../core/sources/data_state.dart';
import '../../../../personal/bookings/domain/entity/booking_entity.dart';
import '../../domain/entities/services_list_responce_entity.dart';
import '../../domain/params/get_business_bookings_params.dart';
import '../../domain/params/get_business_serives_param.dart';
import '../../domain/repositories/business_page_services_repository.dart';
import '../sources/business_booking_remote.dart';
import '../sources/get_service_by_business_id_remote.dart';

class BusinessPageRepositoryImpl implements BusinessPageRepository {
  BusinessPageRepositoryImpl(this.serviceRemote, this.bookingRemote);
  final GetServiceByBusinessIdRemote serviceRemote;
  final BusinessBookingRemote bookingRemote;

  @override
  Future<DataState<ServicesListResponceEntity>> businessServices(
      GetBusinessSerivesParam param) async {
    return await serviceRemote.services(
      param.businessID,
      nextKey: param.nextKey,
      sort: param.sort,
    );
  }

  @override
  Future<DataState<List<BookingEntity>>> getBookings(
    GetBusinessBookingsParams param,
  ) async {
    return await bookingRemote.getBookings(param);
  }
}
