import 'package:flutter/rendering.dart';

import '../../../../../../core/usecase/usecase.dart';
import '../repo/setting_repo.dart';

class GetWalletUsecase implements UseCase<bool, String> {
  GetWalletUsecase(this.repository);
  final SettingRepository repository;

  @override
  Future<DataState<bool>> call(String params) async {
    try {
      return await repository.getWallet(params);
    } catch (e) {
      debugPrint('GetWalletUsecase error: $e');
      return DataFailer<bool>(CustomException('something_wrong'));
    }
  }
}
