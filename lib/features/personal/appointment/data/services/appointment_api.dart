import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/api_call.dart';
import '../../../bookings/data/models/booking_model.dart';
import '../../../bookings/data/sources/local_booking.dart';
import '../../domain/params/hold_service_params.dart';
import '../../domain/params/update_appointment_params.dart';
import '../model/hold_service_payment_model.dart';

abstract interface class AppointmentApi {
  Future<DataState<bool>> updateAppointment(UpdateAppointmentParams params);
  Future<DataState<HoldServiceResponse>> holdServicePayment(
    HoldServiceParams params,
  );
}

class AppointmentApiImpl implements AppointmentApi {
  ///does not retuen a booking whn we update time but returns a booking when we update status
  @override
  Future<DataState<bool>> updateAppointment(
    UpdateAppointmentParams params,
  ) async {
    try {
      debugPrint(json.encode(params.toMap()));
      final String endpoint = '/booking/update/?type=${params.apiKey}';
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.patch,
        body: json.encode(params.toMap()),
        isAuth: true,
        isConnectType: true,
      );
      if (result is DataSuccess) {
        debugPrint(result.data);
        if (params.apiKey == 'status') {
          final Map<String, dynamic> jsonMap = json.decode(result.data ?? '');
          final Map<String, dynamic> updatedMap = jsonMap['updatedBooking'];
          final BookingModel booking = BookingModel.fromMap(updatedMap);
          await LocalBooking().save(booking);
        }
        return DataSuccess<bool>(result.data ?? '', true);
      } else {
        return DataFailer<bool>(
          CustomException(result.exception?.message ?? ''),
        );
      }
    } catch (e) {
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<HoldServiceResponse>> holdServicePayment(
    HoldServiceParams params,
  ) async {
    try {
      debugPrint(json.encode(params.toMap()));
      const String endpoint = '/payment/service';
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        body: json.encode(params.toMap()),
        isAuth: true,
        isConnectType: true,
      );
      if (result is DataSuccess) {
        AppLog.info('', name: 'AppointmnetApi.holdServicePayment - if');
        final HoldServiceResponse holdServiceModel =
            HoldServiceResponse.fromJson(result.data ?? '');
        return DataSuccess<HoldServiceResponse>(
            result.data ?? '', holdServiceModel);
      } else {
        AppLog.error(result.exception?.message ?? 'something_wrong'.tr(),
            name: 'AppointmnetApi.holdServicePayment - else');
        return DataFailer<HoldServiceResponse>(result.exception!);
      }
    } catch (e) {
      AppLog.error('something_wrong'.tr(),
          name: 'AppointmnetApi.holdServicePayment - catch');
      return DataFailer<HoldServiceResponse>(CustomException(e.toString()));
    }
  }
}
