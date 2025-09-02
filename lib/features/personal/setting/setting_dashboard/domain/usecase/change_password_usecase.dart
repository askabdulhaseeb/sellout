import 'package:flutter/material.dart';
import '../../../../../../../core/usecase/usecase.dart';
import '../../view/params/change_password_params.dart';
import '../repo/setting_repo.dart';

class ChangePasswordUseCase implements UseCase<bool, ChangePasswordParams> {
  ChangePasswordUseCase(this.repository);
  final SettingRepository repository;

  @override
  Future<DataState<bool>> call(ChangePasswordParams params) async {
    try {
      return await repository.changePassword(params);
    } catch (e) {
      debugPrint('ChangePasswordUseCase error: $e');
      return DataFailer<bool>(CustomException('something_wrong'));
    }
  }
}
