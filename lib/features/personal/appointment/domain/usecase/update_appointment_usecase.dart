import 'package:flutter/material.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/usecase/usecase.dart';
import '../params/update_appointment_params.dart';
import '../repository/appointment_repository.dart';

class UpdateAppointmentUsecase
    implements UseCase<bool, UpdateAppointmentParams> {
  const UpdateAppointmentUsecase(this._repository);
  final AppointmentRepository _repository;
  @override
  Future<DataState<bool>> call(UpdateAppointmentParams param) async {
    try {
      return await _repository.updateAppointment(param);
    } catch (e, stack) {
      // Log the error or debugprint it for debugging
      debugPrint('❌ Exception in UpdateAppointmentUsecase: $e');
      AppLog.error('somethign_wrong',
          name: 'UpdateAppointmentUsecase - catch', stackTrace: stack);
      // Return a DataFailer with a custom exception
      return DataFailer<bool>(CustomException('Something went wrong: $e'));
    }
  }
}
