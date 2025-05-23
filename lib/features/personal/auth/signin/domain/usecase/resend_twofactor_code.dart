import 'package:flutter/material.dart';

import '../../../../../../core/usecase/usecase.dart';
import '../params/two_factor_params.dart';
import '../repositories/signin_repository.dart';

class ResendTwoFactorUseCase implements UseCase<bool, TwoFactorParams> {
  const ResendTwoFactorUseCase(this.repository);
  final SigninRepository repository;

  @override
  Future<DataState<bool>> call(TwoFactorParams params) async {
    try {
      return await repository.resendTwoFactorCode(params);
    } catch (e) {
      debugPrint('$e');
    }
    return DataFailer<bool>(CustomException('Error'));
  }
}
