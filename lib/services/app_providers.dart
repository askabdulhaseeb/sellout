import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../features/attachment/views/providers/picked_media_provider.dart';
import '../features/business/business_page/views/providers/business_page_provider.dart';
import '../features/personal/cart/views/providers/cart_provider.dart';
import '../features/personal/chats/chat/views/providers/audio_provider.dart';
import '../features/personal/chats/chat/views/providers/chat_provider.dart';
import '../features/personal/listing/listing_form/views/providers/add_listing_form_provider.dart';
import '../features/personal/chats/chat_dashboard/views/providers/chat_dashboard_provider.dart';
import '../features/personal/dashboard/views/providers/personal_bottom_nav_provider.dart';
import '../features/personal/post/feed/views/providers/feed_provider.dart';
import '../features/personal/post/post_detail/views/providers/post_detail_provider.dart';
import '../features/personal/review/features/reivew_list/views/providers/review_list_provider.dart';
import '../features/personal/user/profiles/views/providers/profile_provider.dart';
import 'get_it.dart';

import '../features/personal/auth/signin/views/providers/signin_provider.dart';

final List<SingleChildWidget> appProviders = <SingleChildWidget>[
  // Add your providers here
  ChangeNotifierProvider<SigninProvider>.value(
      value: SigninProvider(locator(), locator())),

  ChangeNotifierProvider<PersonalBottomNavProvider>.value(
      value: PersonalBottomNavProvider()),

  ChangeNotifierProvider<AddListingFormProvider>.value(
      value: AddListingFormProvider()),
  ChangeNotifierProvider<PickedMediaProvider>.value(
      value: PickedMediaProvider()),
  //
  ChangeNotifierProvider<ChatDashboardProvider>.value(
      value: ChatDashboardProvider(locator())),
  ChangeNotifierProvider<ChatProvider>.value(
      value: ChatProvider(locator(), locator())),
  ChangeNotifierProvider<AudioProvider>.value(value: AudioProvider()),
  //
  ChangeNotifierProvider<ProfileProvider>.value(
      value: ProfileProvider(locator(), locator(), locator())),
  //
  ChangeNotifierProvider<FeedProvider>.value(value: FeedProvider(locator())),
  ChangeNotifierProvider<PostDetailProvider>.value(
      value: PostDetailProvider(locator(), locator())),

  ChangeNotifierProvider<CartProvider>.value(
      value:
          CartProvider(locator(), locator(), locator(), locator(), locator())),
  ChangeNotifierProvider<ReviewListProvider>.value(value: ReviewListProvider()),
  // Business
  ChangeNotifierProvider<BusinessPageProvider>.value(
      value: BusinessPageProvider(locator(), locator(), locator(), locator(),locator())),
];
