import 'package:flutter/material.dart';
import '../../../../../../../core/usecase/usecase.dart';
import '../params/create_account_session_params.dart';
import '../repo/setting_repo.dart';

class ConnectAccountSessionUseCase
    implements UseCase<String, ConnectAccountSessionParams> {
  ConnectAccountSessionUseCase(this.repository);
  final SettingRepository repository;

  @override
  Future<DataState<String>> call(ConnectAccountSessionParams params) async {
    try {
      return await repository.connectAccountSession(params);
    } catch (e) {
      debugPrint('ConnectAccountSessionUseCase error: $e');
      return DataFailer<String>(CustomException('something_wrong'));
    }
  }
}
