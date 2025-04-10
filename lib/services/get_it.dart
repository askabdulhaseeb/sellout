import 'package:get_it/get_it.dart';
import '../core/widgets/appointment/data/repository/appointment_repository.dart';
import '../core/widgets/appointment/data/services/appointment_api.dart';
import '../core/widgets/appointment/domain/repository/appointment_repository.dart';
import '../core/widgets/appointment/domain/usecase/update_appointment_usecase.dart';
import '../core/widgets/appointment/providers/appointment_tile_provider.dart';
import '../core/widgets/phone_number/data/repository/phone_number_repository_impl.dart';
import '../core/widgets/phone_number/data/sources/country_api.dart';
import '../core/widgets/phone_number/domain/repository/phone_number_repository.dart';
import '../core/widgets/phone_number/domain/usecase/get_counties_usecase.dart';
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
import '../features/business/service/domain/usecase/update_service-usecase.dart';
import '../features/business/service/views/providers/add_service_provider.dart';
import '../features/personal/auth/find_account/data/repository/find_account_repository_impl.dart';
import '../features/personal/auth/find_account/data/source/find_account_remote_data_source.dart';
import '../features/personal/auth/find_account/domain/repository/find_account_repository.dart';
import '../features/personal/auth/find_account/domain/use_cases/find_account_usecase.dart';
import '../features/personal/auth/find_account/domain/use_cases/newpassword_usecase.dart';
import '../features/personal/auth/find_account/domain/use_cases/send_otp_usecase.dart';
import '../features/personal/auth/find_account/domain/use_cases/verify_otpUsecase.dart';
import '../features/personal/auth/find_account/view/providers/find_account_provider.dart';
import '../features/personal/auth/signin/data/repositories/signin_repository_impl.dart';
import '../features/personal/auth/signin/data/sources/signin_remote_source.dart';
import '../features/personal/auth/signin/domain/repositories/signin_repository.dart';
import '../features/personal/auth/signin/domain/usecase/login_usecase.dart';
import '../features/personal/auth/signin/views/providers/signin_provider.dart';
import '../features/personal/auth/signup/data/repositories/signup_repository_impl.dart';
import '../features/personal/auth/signup/data/sources/signup_api.dart';
import '../features/personal/auth/signup/domain/repositories/signup_repository.dart';
import '../features/personal/auth/signup/domain/usecase/register_user_usecase.dart';
import '../features/personal/auth/signup/domain/usecase/send_opt_usecase.dart';
import '../features/personal/auth/signup/domain/usecase/verify_opt_usecase.dart';
import '../features/personal/auth/signup/views/providers/signup_provider.dart';
import '../features/personal/book_visit/domain/usecase/book_service_usecase.dart';
import '../features/personal/book_visit/domain/usecase/cancel_visit_usecase.dart';
import '../features/personal/book_visit/domain/usecase/update_visit_usecase.dart';
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
import '../features/personal/chats/chat_dashboard/domain/usecase/create_private_chat_usecase.dart';
import '../features/personal/chats/chat_dashboard/domain/usecase/get_my_chats_usecase.dart';
import '../features/personal/chats/chat_dashboard/views/providers/chat_dashboard_provider.dart';
import '../features/personal/explore/data/repository/explore_repository_impl.dart';
import '../features/personal/explore/data/source/explore_remote_source.dart';
import '../features/personal/explore/domain/repository/location_name_repo.dart';
import '../features/personal/explore/domain/usecase/location_name_usecase.dart';
import '../features/personal/explore/views/providers/explore_provider.dart';
import '../features/personal/book_visit/data/repo/visit_book_repo_impl.dart';
import '../features/personal/book_visit/data/source/book_visit_api.dart';
import '../features/personal/book_visit/domain/repo/book_visit_repo.dart';
import '../features/personal/book_visit/domain/usecase/book_visit_usecase.dart';
import '../features/personal/book_visit/view/provider/view_booking_provider.dart';
import '../features/personal/post/data/repositories/post_repository_impl.dart';
import '../features/personal/post/data/sources/remote/post_remote_api.dart';
import '../features/personal/post/domain/repositories/post_repository.dart';
import '../features/personal/post/domain/usecase/add_to_cart_usecase.dart';
import '../features/personal/post/domain/usecase/create_offer_usecase.dart';
import '../features/personal/post/domain/usecase/get_feed_usecase.dart';
import '../features/personal/post/domain/usecase/get_specific_post_usecase.dart';
import '../features/personal/post/domain/usecase/update_offer_usecase.dart';
import '../features/personal/post/feed/views/providers/feed_provider.dart';
import '../features/personal/review/data/repositories/review_repository_impl.dart';
import '../features/personal/review/data/sources/review_remote_api.dart';
import '../features/personal/review/domain/repositories/review_repository.dart';
import '../features/personal/review/domain/usecase/create_review_usecase.dart';
import '../features/personal/review/domain/usecase/get_reviews_usecase.dart';
import '../features/personal/review/features/reivew_list/views/providers/review_provider.dart';
import '../features/personal/services/data/repositories/personal_services_repository_impl.dart';
import '../features/personal/services/data/sources/services_explore_api.dart';
import '../features/personal/services/domain/repositories/personal_services_repository.dart';
import '../features/personal/services/domain/usecase/get_special_offer_usecase.dart';
import '../features/personal/services/views/providers/services_page_provider.dart';
import '../features/personal/user/profiles/data/repositories/user_repository_impl.dart';
import '../features/personal/user/profiles/data/sources/remote/my_visting_remote.dart';
import '../features/personal/user/profiles/data/sources/remote/order_by_user_remote.dart';
import '../features/personal/user/profiles/data/sources/remote/post_by_user_remote.dart';
import '../features/personal/user/profiles/data/sources/remote/user_profile_remote_source.dart';
import '../features/personal/user/profiles/domain/repositories/user_repositories.dart';
import '../features/personal/user/profiles/domain/usecase/edit_profile_detail_usecase.dart';
import '../features/personal/user/profiles/domain/usecase/edit_profile_picture_usecase.dart';
import '../features/personal/user/profiles/domain/usecase/get_my_host_usecase.dart';
import '../features/personal/user/profiles/domain/usecase/get_my_visiting_usecase.dart';
import '../features/personal/user/profiles/domain/usecase/get_orders_buyer_id.dart';
import '../features/personal/user/profiles/domain/usecase/get_post_by_id_usecase.dart';
import '../features/personal/user/profiles/domain/usecase/get_user_by_uid.dart';
import '../features/personal/user/profiles/views/providers/profile_provider.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  _auth();
  _profile();
  _servicePage();
  _message();
  _chat();
  _feed();
  _post();
  _cart();
  _business();
  _booking();
  _services();
  _appointment();
  _review();
  _country();
  _explore();
  _bookvisit();
}

void _auth() {
  locator.registerFactory<SigninRemoteSource>(() => SigninRemoteSourceImpl());
  locator
      .registerFactory<SigninRepository>(() => SigninRepositoryImpl(locator()));
  locator.registerFactory<LoginUsecase>(() => LoginUsecase(locator()));
  locator.registerLazySingleton<SigninProvider>(() => SigninProvider(
        locator(),
      ));
  // Signup
  locator.registerFactory<SignupApi>(() => SignupApiImpl());
  locator
      .registerFactory<SignupRepository>(() => SignupRepositoryImpl(locator()));
  // locator.registerFactory<GetCountiesUsecase>(
  //     () => GetCountiesUsecase(locator()));
  locator.registerFactory<RegisterUserUsecase>(
      () => RegisterUserUsecase(locator()));
  locator.registerFactory<SendPhoneOtpUsecase>(
      () => SendPhoneOtpUsecase(locator()));
  locator.registerFactory<VerifyPhoneOtpUsecase>(
      () => VerifyPhoneOtpUsecase(locator()));
  locator.registerLazySingleton<SignupProvider>(
      () => SignupProvider(locator(), locator(), locator(), locator()));
  locator.registerFactory<FindAccountRemoteDataSource>(
      () => FindAccountRemoteDataSourceimpl());
  locator.registerLazySingleton<FindAccountRepository>(
      () => FindAccountRepositoryImpl(locator()));
  locator.registerLazySingleton<FindAccountUsecase>(
      () => FindAccountUsecase(locator()));
  locator.registerLazySingleton<SendEmailForOtpUsecase>(
      () => SendEmailForOtpUsecase(locator()));
  locator.registerLazySingleton<NewPasswordUsecase>(
      () => NewPasswordUsecase(locator()));
  locator.registerLazySingleton<VerifyOtpUseCase>(
      () => VerifyOtpUseCase(locator()));
  locator.registerFactory<FindAccountProvider>(
      () => FindAccountProvider(locator(), locator(), locator(), locator()));
}

void _servicePage() {
  locator.registerFactory<ServicesExploreApi>(() => ServicesExploreApiImpl());
  locator.registerFactory<PersonalServicesRepository>(
      () => PersonalServicesRepositoryImpl(locator()));
  locator.registerFactory<GetSpecialOfferUsecase>(
      () => GetSpecialOfferUsecase(locator()));
  locator.registerLazySingleton<ServicesPageProvider>(
      () => ServicesPageProvider(locator(), locator(), locator()));
}

void _profile() {
  locator.registerFactory<UserProfileRemoteSource>(
      () => UserProfileRemoteSourceImpl());
  locator.registerFactory<PostByUserRemote>(() => PostByUserRemoteImpl());
  locator.registerFactory<MyVisitingRemote>(() => MyVisitingRemoteImpl());
  locator.registerFactory<OrderByUserRemote>(() => OrderByUserRemoteImpl());
  locator.registerFactory<UserProfileRepository>(() =>
      UserProfileRepositoryImpl(locator(), locator(), locator(), locator()));
  locator.registerFactory<GetUserByUidUsecase>(
      () => GetUserByUidUsecase(locator()));
  locator.registerFactory<GetImVisiterUsecase>(
      () => GetImVisiterUsecase(locator()));
  locator.registerFactory<GetImHostUsecase>(() => GetImHostUsecase(locator()));
  locator
      .registerFactory<GetPostByIdUsecase>(() => GetPostByIdUsecase(locator()));
  locator.registerFactory<GetOrderByUidUsecase>(
      () => GetOrderByUidUsecase(locator()));
  locator.registerFactory<UpdateProfilePictureUsecase>(
      () => UpdateProfilePictureUsecase(locator()));
  locator.registerFactory<UpdateProfileDetailUsecase>(
      () => UpdateProfileDetailUsecase(locator()));
  locator.registerLazySingleton<ProfileProvider>(() => ProfileProvider(
        locator(),
        locator(),
        locator(),
        locator(),
        locator(),
        locator(),
        locator(),
      ));
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
  locator
      .registerFactory<CreateOfferUsecase>(() => CreateOfferUsecase(locator()));
  locator
      .registerFactory<UpdateOfferUsecase>(() => UpdateOfferUsecase(locator()));
  locator.registerLazySingleton<FeedProvider>(() => FeedProvider(
        locator(),
        locator(),
        locator(),
        locator(),
      ));
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
      BusinessPageProvider(locator(), locator(), locator(), locator(),
          locator(), locator(), locator()));
}

void _services() {
  // API
  locator.registerFactory<GetServiceByBusinessIdRemote>(
      () => GetServiceByBusinessIdRemoteImpl());
  locator.registerFactory<ServiceRemoteApi>(() => ServiceRemoteApiImpl());
  locator.registerFactory<AddServiceRemoteApi>(() => AddServiceRemoteApiImpl());

  //
  // REPOSITORIES

  locator.registerFactory<CreatePrivateChatUsecase>(
      () => CreatePrivateChatUsecase(locator()));
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
  locator.registerFactory(() => UpdateServiceUsecase(locator()));
  //
  // Providers
  locator.registerLazySingleton<AddServiceProvider>(
      () => AddServiceProvider(locator(), locator()));
}

void _booking() {
  // API
  locator.registerFactory<BusinessBookingRemote>(
      () => BusinessBookingRemoteImpl());
  //
  // REPOSITORIES
  //
  // USECASES
  locator.registerFactory<GetBookingsListUsecase>(
      () => GetBookingsListUsecase(locator()));
  //
  // Providers
}

void _appointment() {
  // API
  //
  locator.registerFactory<AppointmentApi>(() => AppointmentApiImpl());
  // REPOSITORIES
  //
  locator.registerFactory<AppointmentRepository>(
      () => AppointmentRepositoryImpl(locator()));
  // USECASES
  //
  locator.registerFactory<UpdateAppointmentUsecase>(
      () => UpdateAppointmentUsecase(locator()));
  // Providers
  locator.registerLazySingleton<AppointmentTileProvider>(
      () => AppointmentTileProvider(locator()));
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
  locator.registerFactory<CreateReviewUsecase>(
      () => CreateReviewUsecase(locator()));
  locator.registerFactory<ReviewProvider>(() => ReviewProvider(locator()));

  // Providers
}

void _country() {
  // API
  locator.registerFactory<CountryApi>(() => CountryApiImpl());
  //
  // REPOSITORIES
  locator.registerFactory<PhoneNumberRepository>(
      () => PhoneNumberRepositoryImpl(locator()));
  //
  // USECASES
  locator
      .registerFactory<GetCountiesUsecase>(() => GetCountiesUsecase(locator()));
  // Providers
}

void _explore() {
  locator.registerFactory<ExploreRemoteSource>(() => ExploreRemoteSourceImpl());
  locator.registerFactory<ExploreRepository>(
      () => ExploreRepositoryImpl(locator()));
  locator.registerFactory<LocationByNameUsecase>(
      () => LocationByNameUsecase(locator()));
  locator.registerFactory<ExploreProvider>(
      () => ExploreProvider(locator(), locator()));
}

void _bookvisit() {
  locator.registerFactory<BookVisitApi>(() => BookVisitApiImpl());
  locator.registerFactory<BookVisitRepo>(() => BookVisitRepoImpl(locator()));
  locator
      .registerFactory<UpdateVisitUseCase>(() => UpdateVisitUseCase(locator()));
  locator
      .registerFactory<CancelVisitUseCase>(() => CancelVisitUseCase(locator()));
  locator.registerFactory<BookVisitUseCase>(() => BookVisitUseCase(locator()));
  locator
      .registerFactory<BookServiceUsecase>(() => BookServiceUsecase(locator()));

  locator.registerFactory<BookingProvider>(() => BookingProvider(
      locator(), locator(), locator(), locator(), locator(), locator()));
}
