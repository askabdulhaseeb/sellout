import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppStrings {
  // Hive Boxes
  static String get localAuthBox => 'com.sellout.local-auth';
  static String get localUsersBox => 'com.sellout.local-users';
  static String get localRequestHistory => 'com.sellout.request_history';
  static String get localReviewBox => 'com.sellout.local-review';
  static String get localListingBox => 'com.sellout.local-listing';
  static String get localChatsBox => 'com.sellout.local-chats';
  static String get localChatMessagesBox => 'local-chat-messages';
  static String get localPostsBox => 'com.sellout.local-posts';
  static String get localVisitingsBox => 'com.sellout.local-visitings';
  static String get localCartBox => 'com.sellout.local-carts';
  static String get localBusinesssBox => 'com.sellout.local-businesses';
  static String get localServicesBox => 'com.sellout.local-services';
  static String get localBookingsBox => 'com.sellout.local-bookings';
  static String get localCountryBox => 'com.sellout.local-countries';
  static String get localUnreadMessages => 'com.sellout.local-unread-messages';
  static String get localPromosBox => 'com.sellout.local-promo';

  // [IMAGES]
  // Payment METHODS
  static String get amex => 'assets/images/payment_methods/amex.png';
  static String get applePayBlack =>
      'assets/images/payment_methods/apple-pay-black.png';
  static String get dinersClub =>
      'assets/images/payment_methods/diners-club.png';
  static String get mastercard =>
      'assets/images/payment_methods/mastercard.png';
  static String get paypal => 'assets/images/payment_methods/paypal.png';
  static String get visa => 'assets/images/payment_methods/visa.png';
  static String get stripe => 'assets/images/payment_methods/stripe.png';
  //logo
  static String get selloutLogo => 'assets/images/sellout_logo.png';


  String get baseURL =>
      kDebugMode ? 'http://192.168.0.181:3200' : dotenv.env['baseURL'] ?? '';
}
