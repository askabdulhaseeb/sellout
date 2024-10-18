import 'package:get_it/get_it.dart';

import '../features/personal/auth/signin/data/repositories/signin_repository_impl.dart';
import '../features/personal/auth/signin/data/sources/signin_remote_source.dart';
import '../features/personal/auth/signin/domain/repositories/signin_repository.dart';
import '../features/personal/auth/signin/domain/usecase/forgot_password_usecase.dart';
import '../features/personal/auth/signin/domain/usecase/login_usecase.dart';
import '../features/personal/auth/signin/views/providers/signin_provider.dart';
import '../features/personal/user/profiles/data/repositories/user_repository_impl.dart';
import '../features/personal/user/profiles/data/sources/remote/user_profile_remote_source.dart';
import '../features/personal/user/profiles/domain/repositories/user_repositories.dart';
import '../features/personal/user/profiles/domain/usecase/get_user_by_uid.dart';
import '../features/personal/user/profiles/views/providers/profile_provider.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  _auth();
  _profile();
}

void _auth() {
  locator.registerFactory<SigninRemoteSource>(() => SigninRemoteSourceImpl());
  locator
      .registerFactory<SigninRepository>(() => SigninRepositoryImpl(locator()));
  locator.registerFactory<LoginUsecase>(() => LoginUsecase(locator()));
  locator.registerFactory<ForgotPasswordUsecase>(
      () => ForgotPasswordUsecase(locator()));
  locator.registerLazySingleton<SigninProvider>(
      () => SigninProvider(locator(), locator()));
}

void _profile() {
  locator.registerFactory<UserProfileRemoteSource>(
      () => UserProfileRemoteSourceImpl());
  locator.registerFactory<UserProfileRepository>(
      () => UserProfileRepositoryImpl(locator()));
  locator.registerFactory<GetUserByUidUsecase>(
      () => GetUserByUidUsecase(locator()));
  locator
      .registerLazySingleton<ProfileProvider>(() => ProfileProvider(locator()));
}
