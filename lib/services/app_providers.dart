import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../features/attachment/views/providers/picked_media_provider.dart';
import '../features/personal/listing/listing_form/views/providers/add_listing_form_provider.dart';
import '../features/personal/chats/chat_dashboard/views/providers/chat_dashboard_provider.dart';
import '../features/personal/dashboard/views/providers/personal_bottom_nav_provider.dart';
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
  ChangeNotifierProvider<ChatDashboardProvider>.value(
      value: ChatDashboardProvider(locator())),
  ChangeNotifierProvider<ProfileProvider>.value(
      value: ProfileProvider(locator())),
];
