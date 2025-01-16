import 'package:flutter/material.dart';

import '../../../../features/personal/bookings/domain/entity/booking_entity.dart';
import '../../../functions/app_log.dart';
import '../../../sources/api_call.dart';
import '../../app_snakebar.dart';
import '../domain/params/update_appointment_params.dart';
import '../domain/usecase/update_appointment_usecase.dart';

class AppointmentTileProvider extends ChangeNotifier {
  AppointmentTileProvider(this._updateAppointmentUsecase);
  final UpdateAppointmentUsecase _updateAppointmentUsecase;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> onCancel(BuildContext context, BookingEntity booking) async {
    try {
      if (booking.bookingID == null) return;
      isLoading = true;
      final DataState<bool> result =
          await _updateAppointmentUsecase(UpdateAppointmentParams(
        bookingID: booking.bookingID!,
        newStatus: 'cancel',
      ));
      if (result is DataSuccess) {
        isLoading = false;
        return;
      } else {
        AppSnackBar.showSnackBar(
          // ignore: use_build_context_synchronously
          context, result.exception?.message ?? 'something_wrong',
        );
        isLoading = false;
        return;
      }
    } catch (e) {
      AppSnackBar.showSnackBar(
        // ignore: use_build_context_synchronously
        context,
        e.toString(),
      );
      AppLog.error(
        e.toString(),
        name: 'AppointmentTileProvider.onCancel - catch',
        error: e,
      );
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> onChange(BuildContext context, BookingEntity booking) async {}
  Future<void> onPayNow(BuildContext context, BookingEntity booking) async {}
  Future<void> onBookAgain(BuildContext context, BookingEntity booking) async {}
  Future<void> onLeaveReview(
      BuildContext context, BookingEntity booking) async {}
}
