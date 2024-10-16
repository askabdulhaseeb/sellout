import 'package:get_it/get_it.dart';

import '../features/personal/auth/signin/data/repositories/signin_repository_impl.dart';
import '../features/personal/auth/signin/data/sources/signin_remote_source.dart';
import '../features/personal/auth/signin/domain/repositories/signin_repository.dart';
import '../features/personal/auth/signin/domain/usecase/forgot_password_usecase.dart';
import '../features/personal/auth/signin/domain/usecase/login_usecase.dart';
import '../features/personal/auth/signin/views/providers/signin_provider.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  _auth();
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
