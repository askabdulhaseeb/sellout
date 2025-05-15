import 'package:flutter/material.dart';

import '../../../../sources/api_call.dart';
import '../../domain/params/update_appointment_params.dart';

abstract interface class AppointmentApi {
  Future<DataState<bool>> updateAppointment(UpdateAppointmentParams params);
}

class AppointmentApiImpl implements AppointmentApi {
  @override
  Future<DataState<bool>> updateAppointment(
    UpdateAppointmentParams params,
  ) async {
    try {
      debugPrint(json.encode(params.toMap()));
      const String endpoint = '/booking/update/status';
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.patch,
        body: json.encode(params.toMap()),
        isAuth: true,
        isConnectType: true,
      );
      return result;
    } catch (e) {
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }
}
