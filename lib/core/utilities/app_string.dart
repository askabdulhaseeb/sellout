import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppStrings {
  // static var local;
  // Svg Icons
  static const String selloutMyUsersListIcon =
      'assets/icons/svg_icons/selloutMyUsersListIcon.svg';
  static const String selloutNotificationBellIcon =
      'assets/icons/svg_icons/selloutNotificationBellIcon.svg';
  static const String selloutSearchIcon =
      'assets/icons/svg_icons/selloutSearchIcon.svg';
  static const String selloutShoppingCartIcon =
      'assets/icons/svg_icons/selloutShoppingCartIcon.svg';
  static const String selloutServiceChatIcon =
      'assets/icons/svg_icons/selloutServiceChatIcon.svg';
  static const String selloutOrderChatIcon =
      'assets/icons/svg_icons/selloutOrderChatIcon.svg';
  static const String selloutGroupChatIcon =
      'assets/icons/svg_icons/selloutGroupChatIcon.svg';
  static const String selloutAddChatIcon =
      'assets/icons/svg_icons/selloutAddChatIcon.svg';
  static const String selloutShareIcon =
      'assets/icons/svg_icons/selloutShareIcon.svg';
  static const String selloutSaveIcon =
      'assets/icons/svg_icons/selloutSaveIcon.svg';
  static const String selloutMOreMenuIcon =
      'assets/icons/svg_icons/selloutMOreMenuIcon.svg';
  static const String selloutShareAsMessageIcon =
      'assets/icons/svg_icons/selloutShareAsMessageIcon.svg';
  static const String selloutShareInGroupIcon =
      'assets/icons/svg_icons/selloutShareInGroupIcon.svg';
  static const String selloutBottombarChatsFilledIcon =
      'assets/icons/svg_icons/selloutBottombarChatsFilledIcon.svg';
  static const String selloutBottombarChatsOutlineIcon =
      'assets/icons/svg_icons/selloutBottombarChatsOutlineIcon.svg';
  static const String selloutBottombarHomeOutlineIcon =
      'assets/icons/svg_icons/selloutBottombarHomeOutlineIcon.svg';
  static const String selloutBottombarHomeFilledIcon =
      'assets/icons/svg_icons/selloutBottombarHomeFilledIcon.svg';
  static const String selloutBottombarListingOutlineIcon =
      'assets/icons/svg_icons/selloutBottombarListingOutlineIcon.svg';
  static const String selloutBottombarListingFilledIcon =
      'assets/icons/svg_icons/selloutBottombarListingFilledIcon.svg';
  static const String selloutBottombarMarketplaceOutlineIcon =
      'assets/icons/svg_icons/selloutBottombarMarketplaceOutlineIcon.svg';
  static const String selloutBottombarProfileFilledIcon =
      'assets/icons/svg_icons/selloutBottombarProfileFilledIcon.svg';
  static const String selloutBottombarProfileOutlineIcon =
      'assets/icons/svg_icons/selloutBottombarProfileOutlineIcon.svg';
  static const String selloutBottombarServicesFilledIcon =
      'assets/icons/svg_icons/selloutBottombarServicesFilledIcon.svg';
  static const String selloutBottombarServicesOutlineIcon =
      'assets/icons/svg_icons/selloutBottombarServicesOutlineIcon.svg';

  // png icons
  static const String selloutAddListingItemIcon =
      'assets/icons/png_icons/selloutAddListingItemIcon.png';
  static const String selloutAddListingClothFootIcon =
      'assets/icons/png_icons/selloutAddListingClothFootIcon.png';
  static const String selloutAddListingFoodDrinkIcon =
      'assets/icons/png_icons/selloutAddListingFoodDrinkIcon.png';
  static const String selloutAddListingPetsIcon =
      'assets/icons/png_icons/selloutAddListingPetsIcon.png';
  static const String selloutAddListingPropertyIcon =
      'assets/icons/png_icons/selloutAddListingPropertyIcon.png';
  static const String selloutAddListingVehicleIcon =
      'assets/icons/png_icons/selloutAddListingVehicleIcon.png';

  static const String sel = '';

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
  static String get localColorBox => 'com.sellout.local-colors-box';
  static String get localDropDownListingBox => 'com.sellout.dropdown-listings';
  static String get localPostListCache => 'com.sellout.local-post-list-cache';
  static String get localOrdersBox => 'com.sellout.local-orders-box';
  static String get localNotificationBox =>
      'com.sellout.local-notifications-box';
  // Socket Events
  static String get newMessage => 'new_message';
  static String get updatedMessage => 'updated_message';
  static String get getOnlineUsers => 'getOnlineUsers';
  static String get newNotification => 'new-notification';
  static String get lastSeen => 'lastSeen';
  // audio
  static const String recordingDeleteSound =
      'assets/audio/delete_recording_sound.mp3';
  static const String recordingShareSound =
      'assets/audio/share_recording_sound.mp3';
  static const String recordingStartSound =
      'assets/audio/start_recording_sound.mp3';

  // [IMAGES]
  // Maketplace CATEGORIES
  static const String clothfootmarketplace =
      'assets/images/marketplace_filters/clothfoot_marketplace.jpg';
  static const String fooddrinkmarketplace =
      'assets/images/marketplace_filters/fooddrink_marketplace.jpg';
  static const String petsmarketplaceex =
      'assets/images/marketplace_filters/pets_marketplace.jpg';
  static const String popularmarketplace =
      'assets/images/marketplace_filters/popular_marketplace.jpg';
  static const String propertymarketplace =
      'assets/images/marketplace_filters/property_marketplace.jpg';
  static const String vehiclemarketplace =
      'assets/images/marketplace_filters/vehicle_marketplace.jpg';
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
  //app LOGO
  static String get selloutLogo => 'assets/images/sellout_logo.png';

  String get baseURL =>
      kDebugMode ? 'http://192.168.0.181:3200' : dotenv.env['baseURL'] ?? '';
}
