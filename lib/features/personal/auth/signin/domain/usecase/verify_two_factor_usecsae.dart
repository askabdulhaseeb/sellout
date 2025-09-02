import 'package:flutter/material.dart';
import '../../../../../../core/usecase/usecase.dart';
import '../params/two_factor_params.dart';
import '../repositories/signin_repository.dart';

class VerifyTwoFactorUseCase implements UseCase<bool, TwoFactorParams> {
  const VerifyTwoFactorUseCase(this.repository);
  final SigninRepository repository;

  @override
  Future<DataState<bool>> call(TwoFactorParams params) async {
    try {
      return await repository.verifyTwoFactorAuth(params);
    } catch (e) {
      debugPrint('$e');
    }
    return DataFailer<bool>(CustomException('Error'));
  }
}
