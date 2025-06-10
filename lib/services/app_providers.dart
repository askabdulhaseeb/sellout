import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../core/widgets/appointment/view/providers/appointment_tile_provider.dart';
import '../features/attachment/views/providers/picked_media_provider.dart';
import '../features/business/business_page/views/providers/business_page_provider.dart';
import '../features/business/service/views/providers/add_service_provider.dart';
import '../features/personal/address/add_address/views/provider/add_address_provider.dart';
import '../features/personal/auth/find_account/view/providers/find_account_provider.dart';
import '../features/personal/auth/signup/views/providers/signup_provider.dart';
import '../features/personal/cart/views/providers/cart_provider.dart';
import '../features/personal/chats/chat/views/providers/chat_provider.dart';
import '../features/personal/chats/create_chat/view/provider/create_private_chat_provider.dart';
import '../features/personal/chats/create_chat/view/provider/create_chat_group_provider.dart';
import '../features/personal/marketplace/views/providers/marketplace_provider.dart';
import '../features/personal/listing/listing_form/views/providers/add_listing_form_provider.dart';
import '../features/personal/chats/chat_dashboard/views/providers/chat_dashboard_provider.dart';
import '../features/personal/dashboard/views/providers/personal_bottom_nav_provider.dart';
import '../features/personal/book_visit/view/provider/visiting_provider.dart';
import '../features/personal/post/feed/views/providers/feed_provider.dart';
import '../features/personal/promo/view/provider/promo_provider.dart';
import '../features/personal/post/post_detail/views/providers/post_detail_provider.dart';
import '../features/personal/review/views/providers/review_provider.dart';
import '../features/personal/search/view/provider/search_provider.dart';
import '../features/personal/services/views/providers/services_page_provider.dart';
import '../features/personal/user/profiles/views/providers/profile_provider.dart';
import 'get_it.dart';
import '../features/personal/auth/signin/views/providers/signin_provider.dart';

final List<SingleChildWidget> appProviders = <SingleChildWidget>[
  // Add your providers here
  ChangeNotifierProvider<SigninProvider>.value(
      value: SigninProvider(
    locator(),
    locator(),
    locator(),
  )),
  ChangeNotifierProvider<SignupProvider>.value(
      value: SignupProvider(locator(), locator(), locator(), locator())),
  ChangeNotifierProvider<FindAccountProvider>.value(
      value: FindAccountProvider(locator(), locator(), locator(), locator())),
  //
  ChangeNotifierProvider<PersonalBottomNavProvider>.value(
      value: PersonalBottomNavProvider()),

  ChangeNotifierProvider<AddListingFormProvider>.value(
      value: AddListingFormProvider(locator(), locator())),
  ChangeNotifierProvider<PickedMediaProvider>.value(
      value: PickedMediaProvider()),

  //
  ChangeNotifierProvider<ChatDashboardProvider>.value(
      value: ChatDashboardProvider(locator())),
  ChangeNotifierProvider<ChatProvider>.value(
      value: ChatProvider(
    locator(),
    locator(),
  )),
    ChangeNotifierProvider<CreateChatGroupProvider>.value(
      value: CreateChatGroupProvider(locator())),
       ChangeNotifierProvider<CreatePrivateChatProvider>.value(
      value: CreatePrivateChatProvider(locator())),
  //
  ChangeNotifierProvider<ProfileProvider>.value(
      value: ProfileProvider(locator(), locator(), locator(), locator(),
          locator(), locator(), locator())),

  //
  ChangeNotifierProvider<FeedProvider>.value(
      value: FeedProvider(
    locator(),
    locator(),
    locator(),
    locator(),
  )),
   ChangeNotifierProvider<PromoProvider>.value(
      value: PromoProvider(
    locator(),locator(),

  )),
  ChangeNotifierProvider<PostDetailProvider>.value(
      value: PostDetailProvider(locator(), locator())),
  //
  ChangeNotifierProvider<ServicesPageProvider>.value(
      value: ServicesPageProvider(locator(), locator(), locator())),

  ChangeNotifierProvider<CartProvider>.value(
      value: CartProvider(
          locator(), locator(), locator(), locator(), locator(), locator())),
  ChangeNotifierProvider<ReviewProvider>.value(
      value: ReviewProvider(locator())),
  //
  ChangeNotifierProvider<AppointmentTileProvider>.value(
      value: AppointmentTileProvider(locator())),

  // Business
  ChangeNotifierProvider<BusinessPageProvider>.value(
      value: BusinessPageProvider(locator(), locator(), locator(), locator(),
         locator())),
  ChangeNotifierProvider<AddServiceProvider>.value(
      value: AddServiceProvider(locator(), locator())),
  ChangeNotifierProvider<MarketPlaceProvider>.value(
      value: MarketPlaceProvider(
    locator(),
  )),

//

  ChangeNotifierProvider<BookingProvider>.value(
      value: BookingProvider(
          locator(), locator(), locator(), locator(), locator(), locator())),
//
  ChangeNotifierProvider<AddAddressProvider>.value(
      value: AddAddressProvider(locator(), locator())),
      //
        ChangeNotifierProvider<SearchProvider>.value(
      value:   
SearchProvider( locator())),
];
