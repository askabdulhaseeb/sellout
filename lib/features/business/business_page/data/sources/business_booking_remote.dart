import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/api_call.dart';
import '../../../../personal/bookings/data/models/booking_model.dart';
import '../../../../personal/bookings/data/sources/local_booking.dart';
import '../../../../personal/bookings/domain/entity/booking_entity.dart';
import '../../domain/params/get_business_bookings_params.dart';

abstract interface class BusinessBookingRemote {
  Future<DataState<List<BookingEntity>>> getBookings(GetBookingsParams params);
}

class BusinessBookingRemoteImpl implements BusinessBookingRemote {
  @override
  Future<DataState<List<BookingEntity>>> getBookings(
    GetBookingsParams params,
  ) async {
    try {
      final String endpoint = '/booking/get/query?${params.query}';
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        isAuth: true,
        requestType: ApiRequestType.post,
      );

      if (result is DataSuccess) {
        final String raw = result.data ?? '';
        if (raw.isEmpty) {
          AppLog.info(
            'Empty response from server',
            name: 'BusinessBookingRemoteImpl.getBookings - Raw Empty',
          );
          return DataSuccess<List<BookingEntity>>(raw, <BookingEntity>[]);
        }
        final dynamic data = json.decode(raw);
        final List<dynamic> list = data['data'];
        final List<BookingEntity> bookingsList = <BookingEntity>[];
        if (list.isEmpty) {
          return DataSuccess<List<BookingEntity>>(raw, bookingsList);
        }
        for (dynamic element in list) {
          final BookingEntity booking = BookingModel.fromMap(element);
          await LocalBooking().save(booking);
          bookingsList.add(booking);
        }
        return DataSuccess<List<BookingEntity>>(
          raw,
          bookingsList,
        );
      } else {
        AppLog.error(
          result.exception?.message ?? 'Empty response from server',
          name: 'BusinessBookingRemoteImpl.getBookings - Failer',
          error: result.exception,
        );
        return DataFailer<List<BookingEntity>>(
          result.exception ?? CustomException('something-wrong'.tr()),
        );
      }
      //
    } catch (e) {
      AppLog.error(
        '$e',
        name: 'BusinessBookingRemoteImpl.getBookings - Catch',
        error: e.toString(),
      );
      return DataFailer<List<BookingEntity>>(CustomException(e.toString()));
    }
  }
}
