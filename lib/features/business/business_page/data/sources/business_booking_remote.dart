import 'package:flutter/material.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/api_call.dart';
import '../../../../personal/bookings/data/models/booking_model.dart';
import '../../../../personal/bookings/data/sources/local_booking.dart';
import '../../../../personal/bookings/domain/entity/booking_entity.dart';
import '../../domain/params/get_business_bookings_params.dart';

abstract interface class BusinessBookingRemote {
  Future<DataState<List<BookingEntity>>> getMyBookings(
    GetBookingsParams params,
  );
  Future<DataState<List<BookingEntity>>> getBookingsByServiceId(
    GetBookingsParams params,
  );
}

class BusinessBookingRemoteImpl implements BusinessBookingRemote {
  @override
  Future<DataState<List<BookingEntity>>> getMyBookings(
    GetBookingsParams params,
  ) async {
    const String logTag = 'BookingRemoteImpl.getMyBookings';
    try {
      final String endpoint = '/booking/get/query?${params.query}';

      // ─────────────────────────────────────────────
      // // Caching Disabled — Can be re-enabled later
      // final ApiRequestEntity? cached = await LocalRequestHistory().request(
      //   endpoint: endpoint,
      //   duration: const Duration(hours: 6),
      // );
      // if (cached != null) {
      //   final dynamic data = json.decode(cached.encodedData);
      //   final List<dynamic> list = data['data'];
      //   final List<BookingEntity> parsedBookings =
      //       list.map((dynamic e) => BookingModel.fromMap(e)).toList();
      //   return DataSuccess<List<BookingEntity>>(
      //     'Using cached request data',
      //     parsedBookings,
      //   );
      // }
      // ─────────────────────────────────────────────

      debugPrint('[$logTag] Fetching fresh bookings from: $endpoint');

      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        isAuth: true,
        requestType: ApiRequestType.get,
      );

      if (result is DataSuccess) {
        final String raw = result.data ?? '';
        if (raw.isEmpty) {
          debugPrint('[$logTag] Empty API response.');
          return DataSuccess<List<BookingEntity>>(
            'No data found from API',
            <BookingEntity>[],
          );
        }

        final dynamic data = json.decode(raw);
        final List<dynamic> list = data['data'];
        final List<BookingEntity> bookingsList = <BookingEntity>[];

        for (final dynamic element in list) {
          final BookingEntity booking = BookingModel.fromMap(element);
          await LocalBooking().save(booking.bookingID, booking);
          bookingsList.add(booking);
        }

        debugPrint(
          '[$logTag] Successfully fetched and saved ${bookingsList.length} bookings.',
        );
        return DataSuccess<List<BookingEntity>>(raw, bookingsList);
      } else {
        AppLog.error(
          result.exception?.message ?? 'API failure',
          name: '$logTag - API error',
          error: result.exception,
        );
        return DataSuccess<List<BookingEntity>>(
          'Fallback to empty list due to API error',
          <BookingEntity>[],
        );
      }
    } catch (e) {
      AppLog.error(e.toString(), name: '$logTag - Exception', error: e);
      return DataSuccess<List<BookingEntity>>(
        'Fallback to empty list due to exception',
        <BookingEntity>[],
      );
    }
  }

  @override
  Future<DataState<List<BookingEntity>>> getBookingsByServiceId(
    GetBookingsParams params,
  ) async {
    try {
      final String endpoint = '/booking/get/query?${params.query}';

      //  Do NOT check LocalRequestHistory
      return await _fetchAndParseBookings(endpoint);
    } catch (e) {
      return DataSuccess<List<BookingEntity>>(
        'Fallback to empty list due to exception',
        <BookingEntity>[],
      );
    }
  }

  Future<DataState<List<BookingEntity>>> _fetchAndParseBookings(
    String endpoint,
  ) async {
    final DataState<bool> result = await ApiCall<bool>().call(
      endpoint: endpoint,
      isAuth: true,
      requestType: ApiRequestType.get,
    );

    if (result is DataSuccess) {
      final String raw = result.data ?? '';
      if (raw.isEmpty) {
        return DataSuccess<List<BookingEntity>>(raw, <BookingEntity>[]);
      }

      final dynamic data = json.decode(raw);
      final List<dynamic> list = data['data'];
      final List<BookingEntity> bookingsList = <BookingEntity>[];

      for (final dynamic element in list) {
        final BookingEntity booking = BookingModel.fromMap(element);
        await LocalBooking().save(booking.bookingID, booking);
        bookingsList.add(booking);
      }

      return DataSuccess<List<BookingEntity>>(raw, bookingsList);
    } else {
      return DataSuccess<List<BookingEntity>>(
        'Fallback to empty list due to API error',
        <BookingEntity>[],
      );
    }
  }
}
