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
import '../features/personal/setting/setting_options/terms&policies/privacy_policy.dart';
import '../features/personal/visits/view/visit_calender.dart/screens/visit_calender_screen.dart';
import '../features/personal/basket/views/screens/personal_shopping_basket_screen.dart';
import '../features/personal/chats/chat/views/screens/chat_screen.dart';
import '../features/personal/listing/listing_form/views/screens/add_listing_form_screen.dart';
import '../features/personal/auth/signin/views/screens/sign_in_screen.dart';
import '../features/personal/auth/signup/views/screens/signup_screen.dart';
import '../features/personal/dashboard/views/screens/dashboard_screen.dart';
import '../features/personal/visits/view/book_visit/screens/booking_screen.dart';
import '../features/personal/marketplace/views/screens/pages/buy_again_screen.dart';
import '../features/personal/marketplace/views/screens/pages/market_categorized_filteration_page.dart';
import '../features/personal/marketplace/views/screens/pages/saved_posts_page.dart';
import '../features/personal/notifications/view/screens/notification_screen.dart';
import '../features/personal/order/view/order_buyer_screen/screen/order_buyer_screen.dart';
import '../features/personal/order/view/screens/order_seller_screen.dart';
import '../features/personal/order/view/screens/your_order_screen.dart';
import '../features/personal/post/post_detail/views/screens/post_detail_screen.dart';
import '../features/personal/promo/view/create_promo/screens/create_promo_screen.dart';
import '../features/personal/review/views/screens/write_review_screen.dart';
import '../features/personal/search/view/view/search_screen.dart';
import '../features/personal/services/service_detail/screens/service_detail_screen.dart';
import '../features/personal/setting/setting_dashboard/view/screens/personal_more_information_setting_screen.dart';
import '../features/personal/setting/setting_options/account_edit/screens/edit_setting_account_screen.dart';
import '../features/personal/setting/setting_options/account_edit/screens/personal_setting_account.dart';
import '../features/personal/setting/setting_options/privacy_setting/screen/privacy_screen.dart';
import '../features/personal/setting/setting_options/security/screens/setting_security_screen.dart';
import '../features/personal/setting/setting_options/setting_notification/screens/pages/personal_setting_email_notification_screen.dart';
import '../features/personal/setting/setting_options/setting_notification/screens/pages/personal_setting_push_notification.dart';
import '../features/personal/setting/setting_options/setting_notification/screens/personal_setting_notification_screen.dart';
import '../features/personal/setting/setting_dashboard/view/screens/personal_setting_screen.dart';
import '../features/personal/setting/setting_options/terms&policies/acceptable_user_policy.dart';
import '../features/personal/setting/setting_options/terms&policies/chnage_password_screen.dart';
import '../features/personal/setting/setting_options/terms&policies/community_standard_screeen.dart';
import '../features/personal/setting/setting_options/terms&policies/cookie_policy.dart';
import '../features/personal/setting/setting_options/terms&policies/dispute_resolution_policy.dart';
import '../features/personal/setting/setting_options/terms&policies/terms_condition_screen.dart';
import '../features/personal/setting/setting_options/time_away/screens/automatic_response_screen.dart';
import '../features/personal/setting/setting_options/time_away/screens/time_away_screen.dart';
import '../features/personal/user/profiles/views/params/about_us.dart';
import '../features/personal/user/profiles/views/screens/edit_profile_screen.dart';
import '../features/settings/views/screens/connect_bank_screen.dart';
import 'app_linking.dart';

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
    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'product') {
      final String fullId = uri.pathSegments[1]; // "1234-5678"
      AppNavigator.pushNamed(
        PostDetailScreen.routeName,
        arguments: <String, String>{'pid': fullId},
      );
      return ''; // already pushed, so return nothing
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
    //add listings
    AddListingFormScreen.routeName: (_) => const AddListingFormScreen(),
    // POST
    PostDetailScreen.routeName: (_) => const PostDetailScreen(),
    CreatePromoScreen.routeName: (_) => const CreatePromoScreen(),
    //MarketPlace
    MarketCategorizedFilterationPage.routeName: (_) =>
        const MarketCategorizedFilterationPage(),
    //CHAT
    ChatScreen.routeName: (_) => const ChatScreen(),
    //BOOKING
    BookingScreen.routeName: (_) => const BookingScreen(),
    // Shoppig Basket
    PersonalShoppingBasketScreen.routeName: (_) =>
        const PersonalShoppingBasketScreen(),
    //Review
    WriteReviewScreen.routeName: (_) => const WriteReviewScreen(),
    // Profile
    EditProfileScreen.routeName: (_) => const EditProfileScreen(),
    //services
    AddServiceScreen.routeName: (_) => const AddServiceScreen(),
    ServiceDetailScreen.routeName: (_) => const ServiceDetailScreen(),
    SearchScreen.routeName: (_) => const SearchScreen(),
    NotificationsScreen.routeName: (_) => const NotificationsScreen(),
    OrderSellerScreen.routeName: (_) => const OrderSellerScreen(),
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
    AccountSettingsScreen.routeName: (_) => const AccountSettingsScreen(),
    EditAccountSettingScreen.routeName: (_) => const EditAccountSettingScreen(),
    SettingSecurityScreen.routeName: (_) => const SettingSecurityScreen(),
    PersonalPrivacySettingScreen.routeName: (_) =>
        const PersonalPrivacySettingScreen(),
    AutomaticResponseScreen.routeName: (_) => const AutomaticResponseScreen(),
    TimeAwayScreen.routeName: (_) => const TimeAwayScreen(),
    PrivacyPolicyScreen.routeName: (_) => const PrivacyPolicyScreen(),
    TermsOfServiceScreen.routeName: (_) => const TermsOfServiceScreen(),
    CookiesPolicyScreen.routeName: (_) => const CookiesPolicyScreen(),
    AcceptableUsePolicyScreen.routeName: (_) =>
        const AcceptableUsePolicyScreen(),
    DisputeResolutionScreen.routeName: (_) => const DisputeResolutionScreen(),
    CommunityStandardsScreen.routeName: (_) => const CommunityStandardsScreen(),
    AboutUsScreen.routeName: (_) => const AboutUsScreen(),
    ChangePasswordScreen.routeName: (_) => const ChangePasswordScreen(),
    YourOrdersScreen.routeName: (_) => const YourOrdersScreen(),
    OrderBuyerScreen.routeName: (_) => const OrderBuyerScreen(),
    SavedPostsPage.routeName: (_) => const SavedPostsPage(),
    BuyAgainScreen.routeName: (_) => const BuyAgainScreen(),
    ConnectBankScreen.routeName: (_) => const ConnectBankScreen(),
    //
    VisitCalenderScreen.routeName: (_) => const VisitCalenderScreen(),
  };
}
