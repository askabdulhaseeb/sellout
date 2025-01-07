import 'package:get_it/get_it.dart';

import '../features/business/business_page/data/repositories/business_page_services_repository.dart';
import '../features/business/business_page/data/sources/business_booking_remote.dart';
import '../features/business/business_page/data/sources/get_service_by_business_id_remote.dart';
import '../features/business/business_page/domain/repositories/business_page_services_repository.dart';
import '../features/business/business_page/domain/usecase/get_business_bookings_list_usecase.dart';
import '../features/business/business_page/domain/usecase/get_services_list_by_business_id_usecase.dart';
import '../features/business/business_page/views/providers/business_page_provider.dart';
import '../features/business/core/data/repository/business_repo_impl.dart';
import '../features/business/core/data/sources/business_remote_api.dart';
import '../features/business/core/data/sources/service/service_remote_api.dart';
import '../features/business/core/domain/repository/business_repository.dart';
import '../features/business/core/domain/usecase/get_business_by_id_usecase.dart';
import '../features/business/core/domain/usecase/get_service_by_id_usecase.dart';
import '../features/business/service/data/repositories/add_service_repository_impl.dart';
import '../features/business/service/data/sources/add_service_remote_api.dart';
import '../features/business/service/domain/repositories/add_service_repository.dart';
import '../features/business/service/domain/usecase/add_service_usecase.dart';
import '../features/business/service/views/providers/add_service_provider.dart';
import '../features/personal/auth/signin/data/repositories/signin_repository_impl.dart';
import '../features/personal/auth/signin/data/sources/signin_remote_source.dart';
import '../features/personal/auth/signin/domain/repositories/signin_repository.dart';
import '../features/personal/auth/signin/domain/usecase/forgot_password_usecase.dart';
import '../features/personal/auth/signin/domain/usecase/login_usecase.dart';
import '../features/personal/auth/signin/views/providers/signin_provider.dart';
import '../features/personal/cart/data/repositories/cart_repository_impl.dart';
import '../features/personal/cart/data/repositories/checkout_repository_impl.dart';
import '../features/personal/cart/data/sources/remote/cart_remote_api.dart';
import '../features/personal/cart/data/sources/remote/checkout_remote_api.dart';
import '../features/personal/cart/domain/repositories/cart_repository.dart';
import '../features/personal/cart/domain/repositories/checkout_repository.dart';
import '../features/personal/cart/domain/usecase/cart/cart_item_status_update_usecase.dart';
import '../features/personal/cart/domain/usecase/cart/cart_update_qty_usecase.dart';
import '../features/personal/cart/domain/usecase/cart/get_cart_usecase.dart';
import '../features/personal/cart/domain/usecase/cart/remove_from_cart_usecase.dart';
import '../features/personal/cart/domain/usecase/checkout/get_checkout_usecase.dart';
import '../features/personal/cart/views/providers/cart_provider.dart';
import '../features/personal/chats/chat/data/repositories/message_repository_impl.dart';
import '../features/personal/chats/chat/data/sources/remote/messages_remote_source.dart';
import '../features/personal/chats/chat/domain/repositories/message_reposity.dart';
import '../features/personal/chats/chat/domain/usecase/get_messages_usecase.dart';
import '../features/personal/chats/chat/domain/usecase/send_message_usecase.dart';
import '../features/personal/chats/chat/views/providers/chat_provider.dart';
import '../features/personal/chats/chat_dashboard/data/repositories/chat_repository_impl.dart';
import '../features/personal/chats/chat_dashboard/data/sources/remote/chat_remote_source.dart';
import '../features/personal/chats/chat_dashboard/domain/repositories/chat_repository.dart';
import '../features/personal/chats/chat_dashboard/domain/usecase/get_my_chats_usecase.dart';
import '../features/personal/chats/chat_dashboard/views/providers/chat_dashboard_provider.dart';
import '../features/personal/post/data/repositories/post_repository_impl.dart';
import '../features/personal/post/data/sources/remote/post_remote_api.dart';
import '../features/personal/post/domain/repositories/post_repository.dart';
import '../features/personal/post/domain/usecase/add_to_cart_usecase.dart';
import '../features/personal/post/domain/usecase/get_feed_usecase.dart';
import '../features/personal/post/domain/usecase/get_specific_post_usecase.dart';
import '../features/personal/post/feed/views/providers/feed_provider.dart';
import '../features/personal/review/data/repositories/review_repository_impl.dart';
import '../features/personal/review/data/sources/review_remote_api.dart';
import '../features/personal/review/domain/repositories/review_repository.dart';
import '../features/personal/review/domain/usecase/get_reviews_usecase.dart';
import '../features/personal/user/profiles/data/repositories/user_repository_impl.dart';
import '../features/personal/user/profiles/data/sources/remote/my_visting_remote.dart';
import '../features/personal/user/profiles/data/sources/remote/post_by_user_remote.dart';
import '../features/personal/user/profiles/data/sources/remote/user_profile_remote_source.dart';
import '../features/personal/user/profiles/domain/repositories/user_repositories.dart';
import '../features/personal/user/profiles/domain/usecase/get_my_host_usecase.dart';
import '../features/personal/user/profiles/domain/usecase/get_my_visiting_usecase.dart';
import '../features/personal/user/profiles/domain/usecase/get_post_by_id_usecase.dart';
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
  _cart();
  _business();
  _booking();
  _services();
  _review();
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
  locator.registerFactory<PostByUserRemote>(() => PostByUserRemoteImpl());
  locator.registerFactory<MyVisitingRemote>(() => MyVisitingRemoteImpl());
  locator.registerFactory<UserProfileRepository>(
      () => UserProfileRepositoryImpl(locator(), locator(), locator()));
  locator.registerFactory<GetUserByUidUsecase>(
      () => GetUserByUidUsecase(locator()));
  locator.registerFactory<GetImVisiterUsecase>(
      () => GetImVisiterUsecase(locator()));
  locator.registerFactory<GetImHostUsecase>(() => GetImHostUsecase(locator()));
  locator
      .registerFactory<GetPostByIdUsecase>(() => GetPostByIdUsecase(locator()));
  locator.registerLazySingleton<ProfileProvider>(
      () => ProfileProvider(locator(), locator(), locator()));
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
  locator
      .registerFactory<SendMessageUsecase>(() => SendMessageUsecase(locator()));
  locator.registerLazySingleton(() => ChatProvider(locator(), locator()));
}

void _feed() {
  locator.registerFactory<PostRemoteApi>(() => PostRemoteApiImpl());
  locator.registerFactory<PostRepository>(() => PostRepositoryImpl(locator()));
  locator.registerFactory<GetFeedUsecase>(() => GetFeedUsecase(locator()));
  locator.registerFactory<AddToCartUsecase>(() => AddToCartUsecase(locator()));
  locator.registerLazySingleton<FeedProvider>(() => FeedProvider(locator()));
}

void _post() {
  locator.registerFactory<GetSpecificPostUsecase>(
      () => GetSpecificPostUsecase(locator()));
}

void _cart() {
  // cart
  locator.registerFactory<CartRemoteAPI>(() => CartRemoteAPIImpl());
  locator.registerFactory<CartRepository>(() => CartRepositoryImpl(locator()));
  locator.registerFactory<GetCartUsecase>(() => GetCartUsecase(locator()));
  locator.registerFactory<CartItemStatusUpdateUsecase>(
      () => CartItemStatusUpdateUsecase(locator()));
  locator.registerFactory<RemoveFromCartUsecase>(
      () => RemoveFromCartUsecase(locator()));
  locator.registerFactory<CartUpdateQtyUsecase>(
      () => CartUpdateQtyUsecase(locator()));
  // checkout
  locator.registerFactory<CheckoutRemoteAPI>(() => CheckoutRemoteAPIImpl());
  locator.registerFactory<CheckoutRepository>(
      () => CheckoutRepositoryImpl(locator()));
  locator
      .registerFactory<GetCheckoutUsecase>(() => GetCheckoutUsecase(locator()));
  // provider
  locator.registerLazySingleton<CartProvider>(() =>
      CartProvider(locator(), locator(), locator(), locator(), locator()));
}

void _business() {
  // API
  locator.registerFactory<BusinessCoreAPI>(() => BusinessRemoteAPIImpl());
  //
  // REPOSITORIES
  locator.registerFactory<BusinessRepository>(
      () => BusinessRepositoryImpl(locator(), locator()));
  //
  // USECASES
  locator.registerFactory<GetBusinessByIdUsecase>(
      () => GetBusinessByIdUsecase(locator()));
  //
  // Providers
  locator.registerLazySingleton<BusinessPageProvider>(() =>
      BusinessPageProvider(
          locator(), locator(), locator(), locator(), locator()));
}

void _services() {
  // API
  locator.registerFactory<GetServiceByBusinessIdRemote>(
      () => GetServiceByBusinessIdRemoteImpl());
  locator.registerFactory<ServiceRemoteApi>(() => ServiceRemoteApiImpl());
  locator.registerFactory<AddServiceRemoteApi>(() => AddServiceRemoteApiImpl());

  //
  // REPOSITORIES
  locator.registerFactory<BusinessPageRepository>(
      () => BusinessPageRepositoryImpl(locator(), locator()));
  locator.registerFactory<AddServiceRepository>(
      () => AddServiceRepositoryImpl(locator()));
  //
  // USECASES
  locator.registerFactory<GetServicesListByBusinessIdUsecase>(
      () => GetServicesListByBusinessIdUsecase(locator()));
  locator.registerFactory<GetServiceByIdUsecase>(
      () => GetServiceByIdUsecase(locator()));
  locator.registerFactory(() => AddServiceUsecase(locator()));
  //
  // Providers
  locator.registerLazySingleton<AddServiceProvider>(
      () => AddServiceProvider(locator()));
}

void _booking() {
  // API
  locator.registerFactory<BusinessBookingRemote>(
      () => BusinessBookingRemoteImpl());
  //
  // REPOSITORIES
  //
  // USECASES
  locator.registerFactory<GetBusinessBookingsListUsecase>(
      () => GetBusinessBookingsListUsecase(locator()));
  //
  // Providers
}

void _review() {
  // API
  locator.registerFactory<ReviewRemoteApi>(() => ReviewRemoteApiImpl());
  //
  // REPOSITORIES
  locator
      .registerFactory<ReviewRepository>(() => ReviewRepositoryImpl(locator()));
  //
  // USECASES
  locator
      .registerFactory<GetReviewsUsecase>(() => GetReviewsUsecase(locator()));
  //
  // Providers
}
