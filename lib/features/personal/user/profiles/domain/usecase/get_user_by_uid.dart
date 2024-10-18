import 'dart:developer';

import '../../../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repositories.dart';

class GetUserByUidUsecase implements UseCase<UserEntity?, String> {
  const GetUserByUidUsecase(this.userProfileRepository);
  final UserProfileRepository userProfileRepository;
  @override
  Future<DataState<UserEntity?>> call(String params) async {
    log('⚡️ GetUserByUidUsecase - uid: $params');
    return await userProfileRepository.byUID(params);
  }
}
