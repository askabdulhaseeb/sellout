import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../features/personal/appointment/view/providers/appointment_tile_provider.dart';
import '../features/attachment/views/providers/picked_media_provider.dart';
import '../features/business/business_page/views/providers/business_page_provider.dart';
import '../features/business/service/views/providers/add_service_provider.dart';
import '../features/personal/auth/find_account/view/providers/find_account_provider.dart';
import '../features/personal/auth/signup/views/providers/signup_provider.dart';
import '../features/personal/basket/views/providers/cart_provider.dart';
import '../features/personal/chats/chat/views/providers/chat_provider.dart';
import '../features/personal/chats/chat/views/providers/send_message_provider.dart';
import '../features/personal/chats/create_chat/view/provider/create_private_chat_provider.dart';
import '../features/personal/chats/create_chat/view/provider/create_chat_group_provider.dart';
import '../features/personal/chats/quote/view/provider/quote_provider.dart';
import '../features/personal/marketplace/views/providers/marketplace_provider.dart';
import '../features/personal/listing/listing_form/views/providers/add_listing_form_provider.dart';
import '../features/personal/chats/chat_dashboard/views/providers/chat_dashboard_provider.dart';
import '../features/personal/dashboard/views/providers/personal_bottom_nav_provider.dart';
import '../features/personal/visits/view/book_visit/provider/booking_provider.dart';
import '../features/personal/notifications/view/provider/notification_provider.dart';
import '../features/personal/order/view/provider/order_provider.dart';
import '../features/personal/post/feed/views/providers/feed_provider.dart';
import '../features/personal/promo/view/create_promo/provider/promo_provider.dart';
import '../features/personal/post/post_detail/views/providers/post_detail_provider.dart';
import '../features/personal/review/views/providers/review_provider.dart';
import '../features/personal/search/view/provider/search_provider.dart';
import '../features/personal/services/services_screen/providers/services_page_provider.dart';
import '../features/personal/setting/setting_dashboard/view/providers/personal_setting_provider.dart';
import '../features/personal/setting/setting_options/security/provider/setting_security_provider.dart';
import '../features/personal/user/profiles/views/providers/profile_provider.dart';
import '../features/personal/user/profiles/views/user_profile/providers/user_profile_provider.dart';
import '../features/personal/auth/signin/views/providers/signin_provider.dart';
import '../features/personal/visits/view/visit_calender.dart/providers/visit_calender_provider.dart';
import 'get_it.dart';

final List<SingleChildWidget> appProviders = <SingleChildWidget>[
  // Add your providers here
  ChangeNotifierProvider<SigninProvider>.value(
    value: SigninProvider(locator(), locator(), locator()),
  ),
  ChangeNotifierProvider<SignupProvider>.value(
    value: SignupProvider(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  ),
  ChangeNotifierProvider<FindAccountProvider>.value(
    value: FindAccountProvider(locator(), locator(), locator(), locator()),
  ),
  //
  ChangeNotifierProvider<PersonalBottomNavProvider>.value(
    value: PersonalBottomNavProvider(),
  ),

  ChangeNotifierProvider<AddListingFormProvider>.value(
    value: AddListingFormProvider(locator(), locator()),
  ),
  ChangeNotifierProvider<PickedMediaProvider>.value(
    value: PickedMediaProvider(),
  ),
  //
  ChangeNotifierProvider<ChatDashboardProvider>.value(
    value: ChatDashboardProvider(locator()),
  ),
  ChangeNotifierProvider<SendMessageProvider>.value(
    value: SendMessageProvider(locator(), locator()),
  ),
  ChangeNotifierProvider<ChatProvider>.value(
    value: ChatProvider(locator(), locator(), locator(), locator(), locator()),
  ),

  ChangeNotifierProvider<CreateChatGroupProvider>.value(
    value: CreateChatGroupProvider(locator()),
  ),
  ChangeNotifierProvider<CreatePrivateChatProvider>.value(
    value: CreatePrivateChatProvider(locator()),
  ),
  //
  ChangeNotifierProvider<ProfileProvider>.value(
    value: ProfileProvider(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  ),
  ChangeNotifierProvider<UserProfileProvider>.value(
    value: UserProfileProvider(locator(), locator(), locator()),
  ),
  ChangeNotifierProvider<OrderProvider>.value(value: OrderProvider(locator())),
  //
  ChangeNotifierProvider<FeedProvider>.value(
    value: FeedProvider(locator(), locator(), locator(), locator()),
  ),
  ChangeNotifierProvider<PromoProvider>.value(
    value: PromoProvider(locator(), locator()),
  ),
  ChangeNotifierProvider<PostDetailProvider>.value(
    value: PostDetailProvider(locator(), locator()),
  ),
  //
  ChangeNotifierProvider<ServicesPageProvider>.value(
    value: ServicesPageProvider(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  ),

  ChangeNotifierProvider<CartProvider>.value(
    value: CartProvider(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  ),
  ChangeNotifierProvider<ReviewProvider>.value(
    value: ReviewProvider(locator()),
  ),
  //
  ChangeNotifierProvider<AppointmentTileProvider>.value(
    value: AppointmentTileProvider(locator(), locator(), locator(), locator()),
  ),
  // Business
  ChangeNotifierProvider<BusinessPageProvider>.value(
    value: BusinessPageProvider(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  ),
  ChangeNotifierProvider<AddServiceProvider>.value(
    value: AddServiceProvider(locator(), locator()),
  ),
  //
  ChangeNotifierProvider<BookingProvider>.value(
    value: BookingProvider(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  ),
  //
  ChangeNotifierProvider<SearchProvider>.value(
    value: SearchProvider(locator()),
  ),
  //
  ChangeNotifierProvider<PersonalSettingProvider>.value(
    value: PersonalSettingProvider(locator()),
  ),
  ChangeNotifierProvider<SettingSecurityProvider>.value(
    value: SettingSecurityProvider(locator(), locator()),
  ),
  ChangeNotifierProvider<MarketPlaceProvider>.value(
    value: MarketPlaceProvider(locator()),
  ),
  ChangeNotifierProvider<VisitCalenderProvider>.value(
    value: VisitCalenderProvider(locator()),
  ),
  ChangeNotifierProvider<NotificationProvider>.value(
    value: NotificationProvider(locator(), locator(), locator()),
  ),
  ChangeNotifierProvider<QuoteProvider>.value(
    value: QuoteProvider(locator(), locator(), locator(), locator()),
  ),
]; //
