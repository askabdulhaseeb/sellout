import 'package:get_it/get_it.dart';

import '../features/personal/auth/signin/data/repositories/signin_repository_impl.dart';
import '../features/personal/auth/signin/data/sources/signin_remote_source.dart';
import '../features/personal/auth/signin/domain/repositories/signin_repository.dart';
import '../features/personal/auth/signin/domain/usecase/forgot_password_usecase.dart';
import '../features/personal/auth/signin/domain/usecase/login_usecase.dart';
import '../features/personal/auth/signin/views/providers/signin_provider.dart';
import '../features/personal/chats/chat/data/repositories/message_repository_impl.dart';
import '../features/personal/chats/chat/data/sources/remote/messages_remote_source.dart';
import '../features/personal/chats/chat/domain/repositories/message_reposity.dart';
import '../features/personal/chats/chat/domain/usecase/get_messages_usecase.dart';
import '../features/personal/chats/chat/views/providers/chat_provider.dart';
import '../features/personal/chats/chat_dashboard/data/repositories/chat_repository_impl.dart';
import '../features/personal/chats/chat_dashboard/data/sources/remote/chat_remote_source.dart';
import '../features/personal/chats/chat_dashboard/domain/repositories/chat_repository.dart';
import '../features/personal/chats/chat_dashboard/domain/usecase/get_my_chats_usecase.dart';
import '../features/personal/chats/chat_dashboard/views/providers/chat_dashboard_provider.dart';
import '../features/personal/post/data/repositories/post_repository_impl.dart';
import '../features/personal/post/data/sources/remote/post_remote_api.dart';
import '../features/personal/post/domain/repositories/post_repository.dart';
import '../features/personal/post/domain/usecase/get_feed_usecase.dart';
import '../features/personal/post/domain/usecase/get_specific_post_usecase.dart';
import '../features/personal/post/feed/views/providers/feed_provider.dart';
import '../features/personal/user/profiles/data/repositories/user_repository_impl.dart';
import '../features/personal/user/profiles/data/sources/remote/user_profile_remote_source.dart';
import '../features/personal/user/profiles/domain/repositories/user_repositories.dart';
import '../features/personal/user/profiles/domain/usecase/get_user_by_uid.dart';
import '../features/personal/user/profiles/views/providers/profile_provider.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  _auth();
  _profile();
  _message();
  _chat();
  _feed();
  _post();
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

void _chat() {
  locator.registerFactory<ChatRemoteSource>(() => ChatRemoteSourceImpl());
  locator.registerFactory<ChatRepository>(
      () => ChatRepositoryImpl(remoteSource: locator()));
  locator
      .registerFactory<GetMyChatsUsecase>(() => GetMyChatsUsecase(locator()));
  locator.registerLazySingleton<ChatDashboardProvider>(
      () => ChatDashboardProvider(locator()));
}

void _message() {
  locator
      .registerFactory<MessagesRemoteSource>(() => MessagesRemoteSourceImpl());
  locator.registerFactory<MessageRepository>(
      () => MessageRepositoryImpl(locator()));
  locator
      .registerFactory<GetMessagesUsecase>(() => GetMessagesUsecase(locator()));
  locator.registerLazySingleton(() => ChatProvider(locator()));
}

void _feed() {
  locator.registerFactory<PostRemoteApi>(() => PostRemoteApiImpl());
  locator.registerFactory<PostRepository>(() => PostRepositoryImpl(locator()));
  locator.registerFactory<GetFeedUsecase>(() => GetFeedUsecase(locator()));
  locator.registerLazySingleton<FeedProvider>(() => FeedProvider(locator()));
}

void _post() {
  locator.registerFactory<GetSpecificPostUsecase>(
      () => GetSpecificPostUsecase(locator()));
}
