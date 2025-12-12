import 'package:get_it/get_it.dart';
import '../core/sockets/socket_implementations.dart';
import '../core/sockets/socket_service.dart';
import '../features/business/business_page/domain/usecase/get_bookings_by_service_id_usecase.dart';
import '../features/business/business_page/domain/usecase/get_my_bookings_usecase.dart';
import '../features/personal/address/add_address/domain/usecase/add_selling_address_usecase.dart';
import '../features/personal/address/add_address/views/provider/add_selling_address_provider.dart';
import '../features/personal/appointment/data/repository/appointment_repository.dart';
import '../features/personal/appointment/data/services/appointment_api.dart';
import '../features/personal/appointment/domain/repository/appointment_repository.dart';
import '../features/personal/appointment/domain/usecase/hold_service_payment_usecase.dart';
import '../features/personal/appointment/domain/usecase/update_appointment_usecase.dart';
import '../features/personal/appointment/view/providers/appointment_tile_provider.dart';
import '../core/widgets/phone_number/data/repository/phone_number_repository_impl.dart';
import '../core/widgets/phone_number/data/sources/country_api.dart';
import '../core/widgets/phone_number/domain/repository/phone_number_repository.dart';
import '../core/widgets/phone_number/domain/usecase/get_counties_usecase.dart';
import '../features/business/business_page/data/repositories/business_page_services_repository.dart';
import '../features/business/business_page/data/sources/business_booking_remote.dart';
import '../features/business/business_page/data/sources/get_service_by_business_id_remote.dart';
import '../features/business/business_page/domain/repositories/business_page_services_repository.dart';
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
import '../features/personal/address/add_address/data/repository/add_address_repo_impl.dart';
import '../features/personal/address/add_address/data/source/add_address_remote_source.dart';
import '../features/personal/address/add_address/domain/repo_impl/add_address_repo.dart';
import '../features/personal/address/add_address/domain/usecase/add_address_usecase.dart';
import '../features/personal/address/add_address/domain/usecase/update_address_usecase.dart';
import '../features/personal/address/add_address/views/provider/add_address_provider.dart';
import '../features/personal/auth/find_account/data/repository/find_account_repository_impl.dart';
import '../features/personal/auth/find_account/data/source/find_account_remote_data_source.dart';
import '../features/personal/auth/find_account/domain/repository/find_account_repository.dart';
import '../features/personal/auth/find_account/domain/use_cases/find_account_usecase.dart';
import '../features/personal/auth/find_account/domain/use_cases/newpassword_usecase.dart';
import '../features/personal/auth/find_account/domain/use_cases/send_otp_usecase.dart';
import '../features/personal/auth/find_account/domain/use_cases/verify_otp_usecase.dart';
import '../features/personal/auth/find_account/view/providers/find_account_provider.dart';
import '../features/personal/auth/signin/data/repositories/signin_repository_impl.dart';
import '../features/personal/auth/signin/data/sources/signin_remote_source.dart';
import '../features/personal/auth/signin/domain/repositories/signin_repository.dart';
import '../features/personal/auth/signin/domain/usecase/login_usecase.dart';
import '../features/personal/auth/signin/domain/usecase/logout_usecase.dart';
import '../features/personal/auth/signin/domain/usecase/refresh_token_usecase.dart';
import '../features/personal/auth/signin/domain/usecase/resend_twofactor_code.dart';
import '../features/personal/auth/signin/domain/usecase/verify_two_factor_usecsae.dart';
import '../features/personal/auth/signin/views/providers/signin_provider.dart';
import '../features/personal/auth/signup/data/repositories/signup_repository_impl.dart';
import '../features/personal/auth/signup/data/sources/signup_api.dart';
import '../features/personal/auth/signup/domain/repositories/signup_repository.dart';
import '../features/personal/auth/signup/domain/usecase/is_valid_usecase.dart';
import '../features/personal/auth/signup/domain/usecase/register_user_usecase.dart';
import '../features/personal/auth/signup/domain/usecase/send_opt_usecase.dart';
import '../features/personal/auth/signup/domain/usecase/verify_opt_usecase.dart';
import '../features/personal/auth/signup/domain/usecase/verify_user_by_image_usecase.dart';
import '../features/personal/auth/signup/views/providers/signup_provider.dart';
import '../features/personal/basket/data/repositories/checkout_repository_impl.dart';
import '../features/personal/chats/chat/domain/usecase/create_post_inquiry_usecase.dart';
import '../features/personal/chats/quote/data/repo/quote_repo_impl.dart';
import '../features/personal/chats/quote/data/source/remote/quote_remote_api.dart';
import '../features/personal/chats/quote/domain/repo/quote_repo.dart';
import '../features/personal/chats/quote/domain/usecases/get_service_slots_usecase.dart';
import '../features/personal/chats/quote/domain/usecases/hold_quote_pay_usecase.dart';
import '../features/personal/appointment/domain/usecase/release_payment_usecase.dart';
import '../features/personal/chats/quote/domain/usecases/request_quote_usecase.dart';
import '../features/personal/chats/quote/domain/usecases/update_quote_usecase.dart';
import '../features/personal/chats/quote/view/provider/quote_provider.dart';
import '../features/personal/listing/listing_form/data/repository/categories_repo_impl.dart';
import '../features/personal/listing/listing_form/data/sources/remote/remote_categories_source.dart';
import '../features/personal/listing/listing_form/domain/repository/categories_repo.dart';
import '../features/personal/listing/listing_form/domain/usecase/get_category_by_endpoint_usecase.dart';
import '../features/personal/location/data/repo/location_repo_impl.dart';
import '../features/personal/location/data/source/location_api.dart';
import '../features/personal/location/domain/repo/location_repo.dart';
import '../features/personal/location/domain/usecase/location_name_usecase.dart';
import '../features/personal/location/view/provider/location_field_provider.dart';
import '../features/personal/marketplace/data/source/marketplace_remote_source.dart';
import '../features/personal/payment/data/repositories/payment_repository_impl.dart';
import '../features/personal/payment/data/sources/remote/payment_remote_api.dart';
import '../features/personal/payment/domain/repositories/payment_repository.dart';
import '../features/personal/payment/domain/usecase/get_exchange_rate_usecase.dart';
import '../features/personal/payment/domain/usecase/get_wallet_usecase.dart';
import '../features/personal/services/domain/usecase/get_service_categories_usecase.dart';
import '../features/personal/user/profiles/domain/usecase/delete_user_usecase.dart';
import '../features/personal/visits/domain/usecase/book_service_usecase.dart';
import '../features/personal/visits/domain/usecase/get_visit_by_post_usecase.dart';
import '../features/personal/visits/domain/usecase/update_visit_usecase.dart';
import '../features/personal/basket/data/repositories/cart_repository_impl.dart';
import '../features/personal/basket/data/sources/remote/cart_remote_api.dart';
import '../features/personal/basket/data/sources/remote/checkout_remote_api.dart';
import '../features/personal/basket/domain/repositories/cart_repository.dart';
import '../features/personal/basket/domain/repositories/checkout_repository.dart';
import '../features/personal/basket/domain/usecase/cart/cart_item_status_update_usecase.dart';
import '../features/personal/basket/domain/usecase/cart/cart_update_qty_usecase.dart';
import '../features/personal/basket/domain/usecase/cart/get_cart_usecase.dart';
import '../features/personal/basket/domain/usecase/cart/remove_from_cart_usecase.dart';
import '../features/personal/basket/domain/usecase/checkout/pay_intent_usecase.dart';
import '../features/personal/basket/views/providers/cart_provider.dart';
import '../features/personal/chats/chat/data/repositories/message_repository_impl.dart';
import '../features/personal/chats/chat/data/sources/remote/messages_remote_source.dart';
import '../features/personal/chats/chat/domain/repositories/message_reposity.dart';
import '../features/personal/chats/chat/domain/usecase/get_messages_usecase.dart';
import '../features/personal/chats/chat/domain/usecase/leave_group_usecase.dart';
import '../features/personal/chats/chat/domain/usecase/send_group_invite_usecase.dart';
import '../features/personal/chats/chat/domain/usecase/send_message_usecase.dart';
import '../features/personal/chats/chat/domain/usecase/share_to_chat_usecase.dart';
import '../features/personal/chats/chat/views/providers/chat_provider.dart';
import '../features/personal/chats/chat/views/providers/send_message_provider.dart';
import '../features/personal/chats/chat_dashboard/data/repositories/chat_repository_impl.dart';
import '../features/personal/chats/chat_dashboard/data/sources/remote/chat_remote_source.dart';
import '../features/personal/chats/chat_dashboard/domain/repositories/chat_repository.dart';
import '../features/personal/chats/chat_dashboard/domain/usecase/create_chat_usecase.dart';
import '../features/personal/chats/chat_dashboard/domain/usecase/get_my_chats_usecase.dart';
import '../features/personal/chats/chat_dashboard/views/providers/chat_dashboard_provider.dart';
import '../features/personal/visits/data/repo/visit_book_repo_impl.dart';
import '../features/personal/visits/data/source/book_visit_api.dart';
import '../features/personal/visits/domain/repo/book_visit_repo.dart';
import '../features/personal/visits/domain/usecase/book_visit_usecase.dart';
import '../features/personal/visits/view/book_visit/provider/booking_provider.dart';
import '../features/personal/chats/create_chat/view/provider/create_private_chat_provider.dart';
import '../features/personal/chats/create_chat/view/provider/create_chat_group_provider.dart';
import '../features/personal/listing/listing_form/views/widgets/attachment_selection/cept_group_invite_usecase.dart';
import '../features/personal/marketplace/data/repository/marketplace_repo_impl.dart';
import '../features/personal/marketplace/domain/repository/marketplace_repo.dart';
import '../features/personal/marketplace/domain/usecase/post_by_filters_usecase.dart';
import '../features/personal/marketplace/views/providers/marketplace_provider.dart';
import '../features/personal/listing/listing_form/data/repository/add_listing_repo_impl.dart';
import '../features/personal/listing/listing_form/data/sources/remote/add_listing_remote_api.dart';
import '../features/personal/listing/listing_form/domain/repository/add_listing_repo.dart';
import '../features/personal/listing/listing_form/domain/usecase/add_listing_usecase.dart';
import '../features/personal/listing/listing_form/domain/usecase/edit_listing_usecase.dart';
import '../features/personal/listing/listing_form/views/providers/add_listing_form_provider.dart';
import '../features/personal/notifications/data/repo/notification_repo_impl.dart';
import '../features/personal/notifications/data/source/remote/remote_notification.dart';
import '../features/personal/notifications/domain/repo/notification_repo.dart';
import '../features/personal/notifications/domain/usecase/get_all_notifications_usecase.dart';
import '../features/personal/notifications/view/provider/notification_provider.dart';
import '../features/personal/order/data/repo/order_repo_impl.dart';
import '../features/personal/order/domain/repo/order_repo.dart';
import '../features/personal/order/view/provider/order_provider.dart';
import '../features/personal/post/data/repositories/post_repository_impl.dart';
import '../features/personal/post/data/sources/remote/offer_remote_api.dart';
import '../features/personal/post/data/sources/remote/post_remote_api.dart';
import '../features/personal/post/domain/repositories/post_repository.dart';
import '../features/personal/post/domain/usecase/add_to_cart_usecase.dart';
import '../features/personal/post/domain/usecase/create_offer_usecase.dart';
import '../features/personal/post/domain/usecase/get_feed_usecase.dart';
import '../features/personal/post/domain/usecase/offer_payment_usecase.dart';
import '../features/personal/promo/domain/usecase/get_promo_of_followers_usecase.dart';
import '../features/personal/post/domain/usecase/get_specific_post_usecase.dart';
import '../features/personal/post/domain/usecase/update_offer_usecase.dart';
import '../features/personal/post/feed/views/providers/feed_provider.dart';
import '../features/personal/promo/data/repo/promo_repo_impl.dart';
import '../features/personal/promo/data/source/remote/promo_remote_data_source.dart';
import '../features/personal/promo/domain/repo/promo_repo.dart';
import '../features/personal/promo/domain/usecase/create_promo_usecase.dart';
import '../features/personal/promo/view/create_promo/provider/promo_provider.dart';
import '../features/personal/review/data/repositories/review_repository_impl.dart';
import '../features/personal/review/data/sources/review_remote_api.dart';
import '../features/personal/review/domain/repositories/review_repository.dart';
import '../features/personal/review/domain/usecase/create_review_usecase.dart';
import '../features/personal/review/domain/usecase/get_reviews_usecase.dart';
import '../features/personal/review/views/providers/review_provider.dart';
import '../features/personal/search/data/repository/search_repository_impl.dart';
import '../features/personal/search/data/source/search_remote_source.dart';
import '../features/personal/search/domain/repository/search_repository.dart';
import '../features/personal/search/domain/usecase/search_usecase.dart';
import '../features/personal/search/view/provider/search_provider.dart';
import '../features/personal/search/view/view/search_screen.dart';
import '../features/personal/services/data/repositories/personal_services_repository_impl.dart';
import '../features/personal/services/data/sources/remote/services_explore_api.dart';
import '../features/personal/services/domain/repositories/personal_services_repository.dart';
import '../features/personal/services/domain/usecase/get_services_by_query_usecase.dart';
import '../features/personal/services/domain/usecase/get_special_offer_usecase.dart';
import '../features/personal/services/services_screen/providers/services_page_provider.dart';
import '../features/personal/setting/setting_dashboard/data/source/remote/setting_api.dart';
import '../features/personal/setting/setting_dashboard/data/repo/setting_repo_impl.dart';
import '../features/personal/setting/setting_dashboard/domain/repo/setting_repo.dart';
import '../features/personal/setting/setting_dashboard/domain/usecase/change_password_usecase.dart';
import '../features/personal/setting/setting_dashboard/domain/usecase/connect_account_session_usecase.dart';
import '../features/personal/setting/setting_options/security/provider/setting_security_provider.dart';
import '../features/personal/user/profiles/data/repositories/user_repository_impl.dart';
import '../features/personal/user/profiles/data/sources/remote/my_visting_remote.dart';
import '../features/personal/order/data/source/remote/order_by_user_remote.dart';
import '../features/personal/user/profiles/data/sources/remote/post_by_user_remote.dart';
import '../features/personal/user/profiles/data/sources/remote/user_profile_remote_source.dart';
import '../features/personal/user/profiles/domain/repositories/user_repositories.dart';
import '../features/personal/user/profiles/domain/usecase/add_remove_supporter_usecase.dart';
import '../features/personal/user/profiles/domain/usecase/edit_profile_detail_usecase.dart';
import '../features/personal/user/profiles/domain/usecase/edit_profile_picture_usecase.dart';
import '../features/personal/user/profiles/domain/usecase/get_my_host_usecase.dart';
import '../features/personal/user/profiles/domain/usecase/get_my_visiting_usecase.dart';
import '../features/personal/order/domain/usecase/get_orders_buyer_id.dart';
import '../features/personal/user/profiles/domain/usecase/get_post_by_id_usecase.dart';
import '../features/personal/user/profiles/domain/usecase/get_user_by_uid.dart';
import '../features/personal/order/domain/usecase/update_order_usecase.dart';
import '../features/personal/user/profiles/views/providers/profile_provider.dart';
import '../features/postage/data/repository/postage_repository_impl.dart';
import '../features/postage/data/source/remote/postage_remote_source.dart';
import '../features/postage/domain/repository/postage_repository.dart';
import '../features/postage/domain/usecase/add_order_shipping_usecase.dart';
import '../features/postage/domain/usecase/add_shipping_usecase.dart';
import '../features/postage/domain/usecase/buy_label_usecase.dart';
import '../features/postage/domain/usecase/get_order_postage_detail_usecase.dart';
import '../features/postage/domain/usecase/get_postage_detail_usecase.dart';

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
  _marketplace();
  _bookvisit();
  _addlisting();
  _sockets();
  _addaddress();
  _search();
  _settings();
  _order();
  _notification();
  _location();
  _categories();
  _quote();
  _payment();
  _postage();
}

void _auth() {
  locator.registerFactory<SigninRemoteSource>(() => SigninRemoteSourceImpl());
  locator.registerFactory<SigninRepository>(
    () => SigninRepositoryImpl(locator()),
  );
  locator.registerFactory<LoginUsecase>(() => LoginUsecase(locator()));
  locator.registerFactory<LogoutUsecase>(() => LogoutUsecase(locator()));
  locator.registerFactory<RefreshTokenUsecase>(
    () => RefreshTokenUsecase(locator()),
  );
  locator.registerLazySingleton<SigninProvider>(
    () => SigninProvider(locator(), locator(), locator()),
  );
  // Signup
  locator.registerFactory<SignupApi>(() => SignupApiImpl());
  locator.registerFactory<SignupRepository>(
    () => SignupRepositoryImpl(locator()),
  );
  locator.registerFactory<IsValidUsecase>(() => IsValidUsecase(locator()));
  locator.registerFactory<RegisterUserUsecase>(
    () => RegisterUserUsecase(locator()),
  );
  locator.registerFactory<VerifyTwoFactorUseCase>(
    () => VerifyTwoFactorUseCase(locator()),
  );
  locator.registerFactory<ResendTwoFactorUseCase>(
    () => ResendTwoFactorUseCase(locator()),
  );
  locator.registerFactory<SendPhoneOtpUsecase>(
    () => SendPhoneOtpUsecase(locator()),
  );
  locator.registerFactory<VerifyPhoneOtpUsecase>(
    () => VerifyPhoneOtpUsecase(locator()),
  );
  locator.registerFactory<VerifyUserByImageUsecase>(
    () => VerifyUserByImageUsecase(locator()),
  );
  locator.registerLazySingleton<SignupProvider>(
    () => SignupProvider(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  );
  locator.registerFactory<FindAccountRemoteDataSource>(
    () => FindAccountRemoteDataSourceimpl(),
  );
  locator.registerLazySingleton<FindAccountRepository>(
    () => FindAccountRepositoryImpl(locator()),
  );
  locator.registerLazySingleton<FindAccountUsecase>(
    () => FindAccountUsecase(locator()),
  );
  locator.registerLazySingleton<SendEmailForOtpUsecase>(
    () => SendEmailForOtpUsecase(locator()),
  );
  locator.registerLazySingleton<NewPasswordUsecase>(
    () => NewPasswordUsecase(locator()),
  );
  locator.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(locator()),
  );
  locator.registerFactory<FindAccountProvider>(
    () => FindAccountProvider(locator(), locator(), locator(), locator()),
  );
  locator.registerFactory<DeleteUserUsecase>(
    () => DeleteUserUsecase(locator()),
  );
}

void _servicePage() {
  locator.registerFactory<ServicesExploreApi>(() => ServicesExploreApiImpl());
  locator.registerFactory<PersonalServicesRepository>(
    () => PersonalServicesRepositoryImpl(locator()),
  );
  locator.registerFactory<GetSpecialOfferUsecase>(
    () => GetSpecialOfferUsecase(locator()),
  );
  locator.registerFactory<GetServicesByQueryUsecase>(
    () => GetServicesByQueryUsecase(locator()),
  );
  locator.registerLazySingleton<ServicesPageProvider>(
    () => ServicesPageProvider(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  );
}

void _profile() {
  locator.registerFactory<UserProfileRemoteSource>(
    () => UserProfileRemoteSourceImpl(),
  );
  locator.registerFactory<PostByUserRemote>(() => PostByUserRemoteImpl());
  locator.registerFactory<MyVisitingRemote>(() => MyVisitingRemoteImpl());
  locator.registerFactory<UserProfileRepository>(
    () => UserProfileRepositoryImpl(locator(), locator(), locator(), locator()),
  );
  locator.registerFactory<GetUserByUidUsecase>(
    () => GetUserByUidUsecase(locator()),
  );
  locator.registerFactory<GetImVisiterUsecase>(
    () => GetImVisiterUsecase(locator()),
  );
  locator.registerFactory<GetVisitByPostUsecase>(
    () => GetVisitByPostUsecase(locator()),
  );
  locator.registerFactory<GetImHostUsecase>(() => GetImHostUsecase(locator()));
  locator.registerFactory<GetPostByIdUsecase>(
    () => GetPostByIdUsecase(locator()),
  );
  locator.registerFactory<UpdateProfilePictureUsecase>(
    () => UpdateProfilePictureUsecase(locator()),
  );
  locator.registerFactory<UpdateProfileDetailUsecase>(
    () => UpdateProfileDetailUsecase(locator()),
  );
  locator.registerFactory<AddRemoveSupporterUsecase>(
    () => AddRemoveSupporterUsecase(locator()),
  );
  locator.registerLazySingleton<ProfileProvider>(
    () => ProfileProvider(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  );
}

void _chat() {
  locator.registerFactory<ChatRemoteSource>(() => ChatRemoteSourceImpl());
  locator.registerFactory<ChatRepository>(
    () => ChatRepositoryImpl(remoteSource: locator()),
  );
  locator.registerFactory<GetMyChatsUsecase>(
    () => GetMyChatsUsecase(locator()),
  );
  locator.registerFactory<CreatePostInquiryUsecase>(
    () => CreatePostInquiryUsecase(locator()),
  );
  locator.registerLazySingleton<ChatDashboardProvider>(
    () => ChatDashboardProvider(locator()),
  );
  locator.registerLazySingleton<CreateChatGroupProvider>(
    () => CreateChatGroupProvider(locator()),
  );
  locator.registerLazySingleton<CreatePrivateChatProvider>(
    () => CreatePrivateChatProvider(locator()),
  );
}

void _message() {
  locator.registerFactory<MessagesRemoteSource>(
    () => MessagesRemoteSourceImpl(),
  );
  locator.registerFactory<MessageRepository>(
    () => MessageRepositoryImpl(locator(), locator()),
  );
  locator.registerFactory<GetMessagesUsecase>(
    () => GetMessagesUsecase(locator()),
  );
  locator.registerFactory<SendMessageUsecase>(
    () => SendMessageUsecase(locator()),
  );
  locator.registerFactory<ShareInChatUsecase>(
    () => ShareInChatUsecase(locator()),
  );
  locator.registerFactory<LeaveGroupUsecase>(
    () => LeaveGroupUsecase(locator()),
  );

  locator.registerFactory<OfferPaymentUsecase>(
    () => OfferPaymentUsecase(locator()),
  );
  locator.registerFactory<SendGroupInviteUsecase>(
    () => SendGroupInviteUsecase(locator()),
  );
  locator.registerFactory<AcceptGorupInviteUsecase>(
    () => AcceptGorupInviteUsecase(locator()),
  );
  locator.registerFactory(
    () => ChatProvider(locator(), locator(), locator(), locator(), locator()),
  );
  locator.registerFactory(() => SendMessageProvider(locator(), locator()));
}

void _feed() {
  locator.registerFactory<PostRemoteApi>(() => PostRemoteApiImpl());
  locator.registerFactory<OfferRemoteApi>(() => OfferRemoteApiImpl());

  locator.registerFactory<PostRepository>(
    () => PostRepositoryImpl(locator(), locator()),
  );
  locator.registerFactory<PromoRemoteDataSource>(
    () => PromoRemoteDataSourceImpl(),
  );
  locator.registerFactory<PromoRepository>(
    () => PromoRepositoryImpl(locator()),
  );
  locator.registerFactory<GetFeedUsecase>(() => GetFeedUsecase(locator()));
  locator.registerFactory<AddToCartUsecase>(() => AddToCartUsecase(locator()));
  locator.registerFactory<CreateOfferUsecase>(
    () => CreateOfferUsecase(locator()),
  );
  locator.registerFactory<UpdateOfferUsecase>(
    () => UpdateOfferUsecase(locator()),
  );
  locator.registerFactory<GetPromoFollowerUseCase>(
    () => GetPromoFollowerUseCase(locator()),
  );
  locator.registerLazySingleton<FeedProvider>(
    () => FeedProvider(locator(), locator(), locator(), locator()),
  );
  locator.registerFactory<CreatePromoUsecase>(
    () => CreatePromoUsecase(locator()),
  );

  locator.registerLazySingleton<PromoProvider>(
    () => PromoProvider(locator(), locator()),
  );
}

void _post() {
  locator.registerFactory<GetSpecificPostUsecase>(
    () => GetSpecificPostUsecase(locator()),
  );
}

void _cart() {
  // cart
  locator.registerFactory<CartRemoteAPI>(() => CartRemoteAPIImpl());
  locator.registerFactory<CartRepository>(() => CartRepositoryImpl(locator()));
  locator.registerFactory<GetCartUsecase>(() => GetCartUsecase(locator()));
  locator.registerFactory<CartItemStatusUpdateUsecase>(
    () => CartItemStatusUpdateUsecase(locator()),
  );
  locator.registerFactory<RemoveFromCartUsecase>(
    () => RemoveFromCartUsecase(locator()),
  );
  locator.registerFactory<CartUpdateQtyUsecase>(
    () => CartUpdateQtyUsecase(locator()),
  );
  // checkout
  locator.registerFactory<CheckoutRemoteAPI>(() => CheckoutRemoteAPIImpl());
  locator.registerFactory<CheckoutRepository>(
    () => CheckoutRepositoryImpl(locator()),
  );

  locator.registerFactory<PayIntentUsecase>(() => PayIntentUsecase(locator()));
  // provider
  locator.registerLazySingleton<CartProvider>(
    () => CartProvider(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  );
}

void _business() {
  // API
  locator.registerFactory<BusinessCoreAPI>(() => BusinessRemoteAPIImpl());
  //
  // REPOSITORIES
  locator.registerFactory<BusinessRepository>(
    () => BusinessRepositoryImpl(locator(), locator()),
  );
  //
  // USECASES
  locator.registerFactory<GetBusinessByIdUsecase>(
    () => GetBusinessByIdUsecase(locator()),
  );
  //
  // Providers
  locator.registerLazySingleton<BusinessPageProvider>(
    () => BusinessPageProvider(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  );
}

void _services() {
  // API
  locator.registerFactory<GetServiceByBusinessIdRemote>(
    () => GetServiceByBusinessIdRemoteImpl(),
  );
  locator.registerFactory<ServiceRemoteApi>(() => ServiceRemoteApiImpl());
  locator.registerFactory<AddServiceRemoteApi>(() => AddServiceRemoteApiImpl());

  //
  // REPOSITORIES

  locator.registerFactory<CreateChatUsecase>(
    () => CreateChatUsecase(locator()),
  );
  locator.registerFactory<BusinessPageRepository>(
    () => BusinessPageRepositoryImpl(locator(), locator()),
  );
  locator.registerFactory<AddServiceRepository>(
    () => AddServiceRepositoryImpl(locator()),
  );
  //
  // USECASES
  locator.registerFactory<GetServiceCategoriesUsecase>(
    () => GetServiceCategoriesUsecase(locator()),
  );
  locator.registerFactory<GetServicesListByBusinessIdUsecase>(
    () => GetServicesListByBusinessIdUsecase(locator()),
  );
  locator.registerFactory<GetServiceByIdUsecase>(
    () => GetServiceByIdUsecase(locator()),
  );
  locator.registerFactory(() => AddServiceUsecase(locator()));
  locator.registerFactory(() => UpdateServiceUsecase(locator()));
  //
  // Providers
  locator.registerLazySingleton<AddServiceProvider>(
    () => AddServiceProvider(locator(), locator()),
  );
}

void _booking() {
  // API
  locator.registerFactory<BusinessBookingRemote>(
    () => BusinessBookingRemoteImpl(),
  );
  //
  // REPOSITORIES
  //
  // USECASES
  locator.registerFactory<GetMyBookingsListUsecase>(
    () => GetMyBookingsListUsecase(locator()),
  );
  locator.registerFactory<GetBookingsByServiceIdListUsecase>(
    () => GetBookingsByServiceIdListUsecase(locator()),
  );
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
    () => AppointmentRepositoryImpl(locator()),
  );
  // USECASES
  //

  locator.registerFactory<UpdateAppointmentUsecase>(
    () => UpdateAppointmentUsecase(locator()),
  );
  locator.registerFactory<HoldServicePaymentUsecase>(
    () => HoldServicePaymentUsecase(locator()),
  );
  locator.registerFactory<ReleasePaymentUsecase>(
    () => ReleasePaymentUsecase(locator()),
  );
  // Providers
  locator.registerFactory<AppointmentTileProvider>(
    () => AppointmentTileProvider(locator(), locator(), locator(), locator()),
  );
}

void _review() {
  // API
  locator.registerFactory<ReviewRemoteApi>(() => ReviewRemoteApiImpl());
  //
  // REPOSITORIES
  locator.registerFactory<ReviewRepository>(
    () => ReviewRepositoryImpl(locator()),
  );
  //
  // USECASES
  locator.registerFactory<GetReviewsUsecase>(
    () => GetReviewsUsecase(locator()),
  );
  //
  locator.registerFactory<CreateReviewUsecase>(
    () => CreateReviewUsecase(locator()),
  );
  locator.registerFactory<ReviewProvider>(() => ReviewProvider(locator()));

  // Providers
}

void _country() {
  // API
  locator.registerFactory<CountryApi>(() => CountryApiImpl());
  //
  // REPOSITORIES
  locator.registerFactory<PhoneNumberRepository>(
    () => PhoneNumberRepositoryImpl(locator()),
  );
  //
  // USECASES
  locator.registerFactory<GetCountiesUsecase>(
    () => GetCountiesUsecase(locator()),
  );
  // Providers
}

void _marketplace() {
  locator.registerFactory<MarketPlaceRemoteSource>(
    () => MarketPlaceRemoteSourceImpl(),
  );
  locator.registerFactory<GetPostByFiltersUsecase>(
    () => GetPostByFiltersUsecase(locator()),
  );
  locator.registerFactory<MarketPlaceRepo>(
    () => MarketPlaceRepoImpl(locator()),
  );
  locator.registerFactory<MarketPlaceProvider>(
    () => MarketPlaceProvider(locator()),
  );
}

void _bookvisit() {
  locator.registerFactory<BookVisitApi>(() => BookVisitApiImpl());
  locator.registerFactory<BookVisitRepo>(() => BookVisitRepoImpl(locator()));
  locator.registerFactory<UpdateVisitUseCase>(
    () => UpdateVisitUseCase(locator()),
  );
  // locator.registerFactory<UpdateVisitStatusUseCase>(
  //     () => UpdateVisitStatusUseCase(locator()));
  locator.registerFactory<BookVisitUseCase>(() => BookVisitUseCase(locator()));
  locator.registerFactory<BookServiceUsecase>(
    () => BookServiceUsecase(locator()),
  );

  locator.registerFactory<BookingProvider>(
    () => BookingProvider(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  );
}

void _addlisting() {
  locator.registerFactory<AddListingRemoteApi>(() => AddListingRemoteApiImpl());

  locator.registerFactory<AddListingRepo>(() => AddListingRepoImpl(locator()));
  locator.registerFactory<AddListingUsecase>(
    () => AddListingUsecase(locator()),
  );
  locator.registerFactory<EditListingUsecase>(
    () => EditListingUsecase(locator()),
  );
  locator.registerFactory<AddListingFormProvider>(
    () => AddListingFormProvider(locator(), locator()),
  );
}

void _sockets() {
  // SocketImplementations must be a singleton to share online status across the app
  locator.registerLazySingleton<SocketImplementations>(
    () => SocketImplementations(),
  );
  locator.registerFactory<SocketService>(() => SocketService(locator()));
}

void _addaddress() {
  // API
  locator.registerFactory<AddAddressRemoteSource>(
    () => AddAddressRemoteSourceImpl(),
  );
  //
  // REPOSITORIES
  locator.registerFactory<AddAddressRepository>(
    () => AddAddressRepositoryImpl(locator()),
  );
  //
  // USECASES
  locator.registerFactory<AddAddressUsecase>(
    () => AddAddressUsecase(locator()),
  );
  locator.registerFactory<UpdateAddressUsecase>(
    () => UpdateAddressUsecase(locator()),
  );
  locator.registerFactory<AddSellingAddressUsecase>(
    () => AddSellingAddressUsecase(locator()),
  );
  //
  // Providers
  locator.registerFactory<AddAddressProvider>(
    () => AddAddressProvider(locator(), locator()),
  );

  locator.registerFactory<AddSellingAddressProvider>(
    () => AddSellingAddressProvider(locator()),
  );
}

void _search() {
  // API
  //
  locator.registerFactory<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(),
  );
  // REPOSITORIES
  //
  locator.registerFactory<SearchRepository>(
    () => SearchRepositoryImpl(locator()),
  );
  // USECASES
  //
  locator.registerFactory<SearchUsecase>(() => SearchUsecase(locator()));
  // Providers
  locator.registerFactory<SearchProvider>(() => SearchProvider(locator()));
  locator.registerFactory<SearchScreen>(() => const SearchScreen());
}

void _settings() {
  // API
  //
  locator.registerFactory<SettingRemoteApi>(() => SettingRemoteApiImpl());
  // REPOSITORIES
  //
  locator.registerFactory<SettingRepository>(
    () => SettingRepositoryImpl(locator()),
  );
  // USECASES
  //
  locator.registerFactory<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(locator()),
  );
  locator.registerFactory<ConnectAccountSessionUseCase>(
    () => ConnectAccountSessionUseCase(locator()),
  );
  // Providers
  locator.registerFactory<SettingSecurityProvider>(
    () => SettingSecurityProvider(locator(), locator()),
  );
}

void _order() {
  // API
  //
  locator.registerFactory<OrderByUserRemote>(() => OrderByUserRemoteImpl());
  // REPOSITORIES
  locator.registerFactory<OrderRepository>(
    () => OrderRepositoryImpl(locator()),
  );
  // USECASES
  locator.registerFactory<GetOrderByUidUsecase>(
    () => GetOrderByUidUsecase(locator()),
  );
  locator.registerFactory<UpdateOrderUsecase>(
    () => UpdateOrderUsecase(locator()),
  );
  // Providers
  locator.registerFactory<OrderProvider>(() => OrderProvider(locator()));
  // locator.registerLazySingleton<PersonalSettingBuyerOrderProvider>(
  //     () => PersonalSettingBuyerOrderProvider(locator()));
}

void _notification() {
  // API
  locator.registerFactory<NotificationRemote>(() => NotificationRemoteImpl());
  // REPOSITORIES
  locator.registerFactory<NotificationRepository>(
    () => NotificationRepositoryImpl(locator()),
  );
  // USECASES
  //
  locator.registerFactory<GetAllNotificationsUseCase>(
    () => GetAllNotificationsUseCase(locator()),
  );

  // Providers
  locator.registerFactory<NotificationProvider>(
    () => NotificationProvider(locator()),
  );
}

void _location() {
  // Api
  locator.registerFactory<LocationApi>(() => LocationApiImpl());
  // REPOSITORIES
  locator.registerFactory<LocationRepo>(() => LocationRepoImpl(locator()));
  // USECASES
  locator.registerFactory<NominationLocationUsecase>(
    () => NominationLocationUsecase(locator()),
  );
  //Providers
  locator.registerFactory<LocationProvider>(() => LocationProvider(locator()));
}

void _categories() {
  // API
  locator.registerFactory<RemoteCategoriesSource>(
    () => RemoteCategoriesSourceImpl(),
  );
  // REPOSITORIES
  locator.registerFactory<CategoriesRepo>(() => CategoriesRepoImpl(locator()));
  // USECASES
  locator.registerFactory<GetCategoryByEndpointUsecase>(
    () => GetCategoryByEndpointUsecase(locator()),
  );
}

void _quote() {
  locator.registerFactory<QuoteRemoteDataSource>(
    () => QuoteRemoteDataSourceImpl(),
  );
  locator.registerFactory<QuoteRepo>(() => QuoteRepoImpl(locator()));
  locator.registerFactory<RequestQuoteUsecase>(
    () => RequestQuoteUsecase(locator()),
  );
  locator.registerFactory<HoldQuotePayUsecase>(
    () => HoldQuotePayUsecase(locator()),
  );
  locator.registerFactory<UpdateQuoteUsecase>(
    () => UpdateQuoteUsecase(locator()),
  );
  locator.registerFactory<GetServiceSlotsUsecase>(
    () => GetServiceSlotsUsecase(locator()),
  );

  locator.registerFactory<QuoteProvider>(
    () => QuoteProvider(locator(), locator(), locator(), locator()),
  );
}

void _payment() {
  locator.registerFactory<PaymentRemoteApi>(() => PaymentRemoteApiImpl());
  locator.registerFactory<PaymentRepository>(
    () => PaymentRepositoryImpl(locator()),
  );
  locator.registerFactory<GetExchangeRateUsecase>(
    () => GetExchangeRateUsecase(locator()),
  );
  locator.registerFactory<GetWalletUsecase>(() => GetWalletUsecase(locator()));
}

void _postage() {
  locator.registerFactory<PostageRemoteApi>(() => PostageRemoteApiImpl());
  locator.registerFactory<PostageRepository>(
    () => PostageRepositoryImpl(locator()),
  );
  locator.registerFactory<GetPostageDetailUsecase>(
    () => GetPostageDetailUsecase(locator()),
  );
  locator.registerFactory<BuyLabelUsecase>(() => BuyLabelUsecase(locator()));

  locator.registerFactory<GetOrderPostageDetailUsecase>(
    () => GetOrderPostageDetailUsecase(locator()),
  );
  locator.registerFactory<AddOrderShippingUsecase>(
    () => AddOrderShippingUsecase(locator()),
  );
  locator.registerFactory<AddShippingUsecase>(
    () => AddShippingUsecase(locator()),
  );
}
