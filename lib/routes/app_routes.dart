import 'package:flutter/material.dart';
import '../core/functions/app_log.dart';
import '../features/business/service/views/screens/add_service_screen.dart';
import '../features/personal/auth/find_account/view/screens/confirm_email_screen.dart';
import '../features/personal/auth/find_account/view/screens/enter_code_screen.dart';
import '../features/personal/auth/find_account/view/screens/find_account_screen.dart';
import '../features/personal/auth/find_account/view/screens/new_password_screen.dart';
import '../features/personal/auth/find_account/view/screens/send_code_screen.dart';
import '../features/personal/auth/signin/views/screens/verify_two_factor_screen.dart';
import '../features/personal/auth/welcome_screen/view/screens/welcome_screen.dart';
import '../features/personal/cart/views/screens/personal_cart_screen.dart';
import '../features/personal/chats/chat/views/screens/chat_screen.dart';
import '../features/personal/marketplace/views/screens/filter_categories/explore_cloth_foot_screen.dart';
import '../features/personal/marketplace/views/screens/filter_categories/explore_food_drink_screen.dart';
import '../features/personal/marketplace/views/screens/filter_categories/explore_pets_screen.dart';
import '../features/personal/marketplace/views/screens/filter_categories/explore_popular_screen.dart';
import '../features/personal/marketplace/views/screens/filter_categories/explore_property_screen.dart';
import '../features/personal/marketplace/views/screens/filter_categories/explore_vehicles_screen.dart';
import '../features/personal/listing/listing_form/views/screens/add_listing_form_screen.dart';
import '../features/personal/auth/signin/views/screens/sign_in_screen.dart';
import '../features/personal/auth/signup/views/screens/signup_screen.dart';
import '../features/personal/dashboard/views/screens/dashboard_screen.dart';
import '../features/personal/book_visit/view/screens/booking_screen.dart';
import '../features/personal/post/post_detail/views/screens/post_detail_screen.dart';
import '../features/personal/promo/view/screens/create_promo_screen.dart';
import '../features/personal/review/views/screens/write_review_screen.dart';
import '../features/personal/search/view/view/search_screen.dart';
import '../features/personal/setting/more_info/views/screens/personal_more_information_setting_screen.dart';
import '../features/personal/setting/view/setting_options/security/view/screens/setting_security_screen.dart';
import '../features/personal/setting/view/setting_options/setting_notification/view/screens/personal_setting_email_notification_screen.dart';
import '../features/personal/setting/view/setting_options/setting_notification/view/screens/personal_setting_notification_screen.dart';
import '../features/personal/setting/setting_dashboard/views/screens/personal_setting_screen.dart';
import '../features/personal/setting/view/setting_options/setting_notification/view/screens/personal_setting_push_notification.dart';
import '../features/personal/user/profiles/views/screens/edit_profile_screen.dart';

class AppRoutes {
  static const String baseURL = 'https://selloutweb.com';
  static String fromUriToRouteName(Uri? uri) {
    AppLog.info(
      'Starting URI Search.... $uri - Path: ${uri?.path}',
      name: 'AppRoutes.fromUriToRouteName',
    );
    if (uri == null) return DashboardScreen.routeName;
    if (uri.origin == baseURL && uri.path.isEmpty && uri.query.isEmpty) {
      return DashboardScreen.routeName;
    }
    switch (uri.path) {
      // AUTH
      case SignInScreen.routeName:
        return SignInScreen.routeName;
      case SignupScreen.routeName:
        return SignupScreen.routeName;

      // DASHBOARD
      case '':
      case '/':
      case '/overview':
        return DashboardScreen.routeName;
      default:
        return WelcomeScreen.routeName;
    }
  }

  static Map<String, Widget Function(BuildContext)> routes =
      <String, WidgetBuilder>{
    // AUTH
    WelcomeScreen.routeName: (_) => const WelcomeScreen(),
    SignInScreen.routeName: (_) => const SignInScreen(),
    SignupScreen.routeName: (_) => const SignupScreen(),
    FindAccountScreen.routeName: (_) => const FindAccountScreen(),
    ConfirmEmailScreen.routeName: (_) => const ConfirmEmailScreen(),
    SendCodeScreen.routeName: (_) => const SendCodeScreen(),
    EnterCodeScreen.routeName: (_) => const EnterCodeScreen(),
    NewPasswordScreen.routeName: (_) => const NewPasswordScreen(),
    VerifyTwoFactorScreen.routeName: (_) => const VerifyTwoFactorScreen(),
    // DAHSBOARD
    DashboardScreen.routeName: (_) => const DashboardScreen(),
    AddListingFormScreen.routeName: (_) => const AddListingFormScreen(),
    // POST
    PostDetailScreen.routeName: (_) => const PostDetailScreen(),
    CreatePromoScreen.routeName: (_) => const CreatePromoScreen(),
    //CHAT
    ChatScreen.routeName: (_) => const ChatScreen(),
    //BOOKING
    BookingScreen.routeName: (_) => const BookingScreen(),
    // CART
    PersonalCartScreen.routeName: (_) => const PersonalCartScreen(),
    // SETTINGS
    PersonalSettingScreen.routeName: (_) => const PersonalSettingScreen(),
    PersonalSettingMoreInformationScreen.routeName: (_) =>
        const PersonalSettingMoreInformationScreen(),
    PersonalSettingNotificationScreen.routeName: (_) =>
        const PersonalSettingNotificationScreen(),
    PersonalSettingPushNotificationScreen.routeName: (_) =>
        const PersonalSettingPushNotificationScreen(),
    PersonalSettingEmailNotificationScreen.routeName: (_) =>
        const PersonalSettingEmailNotificationScreen(),
    SettingSecurityScreen.routeName: (_) => const SettingSecurityScreen(),
    //Review
    WriteReviewScreen.routeName: (_) => const WriteReviewScreen(),
    // Explore
    ExplorePopularScreen.routeName: (_) => const ExplorePopularScreen(),
    ExploreCLothFOotScreen.routeName: (_) => const ExploreCLothFOotScreen(),
    ExplorePetsScreen.routeName: (_) => const ExplorePetsScreen(),
    ExplorePropertyScreen.routeName: (_) => const ExplorePropertyScreen(),
    ExploreFoodDrinkScreen.routeName: (_) => const ExploreFoodDrinkScreen(),
    ExploreVehiclesScreen.routeName: (_) => const ExploreVehiclesScreen(),
    // Profile
    EditProfileScreen.routeName: (_) => const EditProfileScreen(),
    //services
    AddServiceScreen.routeName: (_) => const AddServiceScreen(),
    SearchScreen.routeName: (_) => const SearchScreen(),
  };
}
