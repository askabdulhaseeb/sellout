import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import '../../../features/personal/order/domain/entities/fast_delivery_entity.dart';
import '../../../features/personal/order/domain/entities/postage_entity.dart';
import '../../../features/personal/order/domain/entities/shipping_detail_entity.dart';
import '../../utilities/app_string.dart';
import '../../../features/attachment/domain/entities/attachment_entity.dart';
import '../../../features/business/core/data/sources/local_business.dart';
import '../../../features/business/core/data/sources/service/local_service.dart';
import '../../../features/business/core/domain/entity/business_address_entity.dart';
import '../../../features/business/core/domain/entity/business_employee_entity.dart';
import '../../../features/business/core/domain/entity/business_entity.dart';
import '../../../features/business/core/domain/entity/business_travel_detail_entity.dart';
import '../../../features/business/core/domain/entity/routine_entity.dart';
import '../../../features/business/core/domain/entity/service/service_entity.dart';
import '../../../features/personal/auth/signin/domain/entities/address_entity.dart';
import '../../../features/personal/auth/signin/domain/entities/login_detail_entity.dart';
import '../../../features/personal/auth/signin/domain/entities/login_info_entity.dart';
import '../../../features/personal/auth/stripe/domain/entities/stripe_connect_account_entity.dart';
import '../../../features/personal/bookings/data/sources/local_booking.dart';
import '../../../features/personal/bookings/domain/entity/booking_entity.dart';
import '../../../features/personal/bookings/domain/entity/booking_payment_detail_entity.dart';
import '../../../features/personal/basket/data/sources/local/local_cart.dart';
import '../../../features/personal/chats/chat/data/sources/local/local_message.dart';
import '../../../features/personal/chats/chat/domain/entities/getted_message_entity.dart';
import '../../../features/personal/chats/chat/domain/entities/message_last_evaluated_key_entity.dart';
import '../../../features/personal/chats/chat_dashboard/data/sources/local/local_chat.dart';
import '../../../features/personal/chats/chat_dashboard/data/sources/local/local_unseen_messages.dart';
import '../../../features/personal/chats/chat_dashboard/domain/entities/chat/chat_entity.dart';
import '../../../features/personal/chats/chat_dashboard/domain/entities/chat/group/group_into_entity.dart';
import '../../../features/personal/chats/chat_dashboard/domain/entities/chat/participant/chat_participant_entity.dart';
import '../../../features/personal/chats/chat_dashboard/domain/entities/chat/participant/invitation_entity.dart';
import '../../../features/personal/chats/chat_dashboard/domain/entities/chat/unread_message_entity.dart';
import '../../../features/personal/chats/chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../features/personal/chats/chat_dashboard/domain/entities/messages/message_post_detail_entity.dart';
import '../../../features/personal/chats/quote/domain/entites/quote_detail_entity.dart';
import '../../../features/personal/chats/quote/domain/entites/service_employee_entity.dart';
import '../../../features/personal/listing/listing_form/data/sources/local/local_colors.dart';
import '../../../features/personal/listing/listing_form/data/sources/local/local_categories.dart';
import '../../../features/personal/listing/listing_form/data/sources/local/local_listing.dart';
import '../../../features/personal/listing/listing_form/domain/entities/category_entites/categories_entity.dart';
import '../../../features/personal/listing/listing_form/domain/entities/category_entites/subentities/parent_dropdown_entity.dart';
import '../../../features/personal/listing/listing_form/domain/entities/category_entites/subentities/dropdown_option_data_entity.dart';
import '../../../features/personal/listing/listing_form/domain/entities/category_entites/subentities/dropdown_option_entity.dart';
import '../../../features/personal/listing/listing_form/domain/entities/color_options_entity.dart';
import '../../../features/personal/listing/listing_form/domain/entities/listing_entity.dart';
import '../../../features/personal/listing/listing_form/domain/entities/sub_category_entity.dart';
import '../../../features/personal/auth/signin/data/sources/local/local_auth.dart';
import '../../../features/personal/location/domain/entities/location_entity.dart';
import '../../../features/personal/notifications/data/source/local/local_notification.dart';
import '../../../features/personal/notifications/domain/entities/notification_entity.dart';
import '../../../features/personal/notifications/domain/entities/notification_metadata_entity.dart';
import '../../../features/personal/post/data/sources/local/local_post.dart';
import '../../../features/personal/post/domain/entities/discount_entity.dart';
import '../../../features/personal/post/domain/entities/feed/feed_entity.dart';
import '../../../features/personal/post/domain/entities/meetup/availability_entity.dart';
import '../../../features/personal/post/domain/entities/offer/offer_amount_info_entity.dart';
import '../../../features/personal/post/domain/entities/offer/offer_detail_entity.dart';
import '../../../features/personal/post/domain/entities/post/package_detail_entity.dart';
import '../../../features/personal/post/domain/entities/post/post_cloth_foot_entity.dart';
import '../../../features/personal/post/domain/entities/post/post_entity.dart';
import '../../../features/personal/post/domain/entities/post/post_food_drink_entity.dart';
import '../../../features/personal/post/domain/entities/post/post_item_entity.dart';
import '../../../features/personal/post/domain/entities/post/post_pet_entity.dart';
import '../../../features/personal/post/domain/entities/post/post_property_entity.dart';
import '../../../features/personal/post/domain/entities/post/post_vehicle_entity.dart';
import '../../../features/personal/post/domain/entities/size_color/color_entity.dart';
import '../../../features/personal/post/domain/entities/size_color/size_color_entity.dart';
import '../../../features/personal/post/domain/entities/visit/visiting_entity.dart';
import '../../../features/personal/post/feed/views/enums/counter_offer_enum.dart';
import '../../../features/personal/promo/data/source/local/local_promo.dart';
import '../../../features/personal/promo/domain/entities/promo_entity.dart';
import '../../../features/personal/review/data/sources/local_review.dart';
import '../../../features/personal/review/domain/entities/review_entity.dart';
import '../../../features/personal/services/data/sources/local/local_service_categories.dart';
import '../../../features/personal/services/domain/entity/service_category_entity.dart';
import '../../../features/personal/services/domain/entity/service_type_entity.dart';
import '../../../features/personal/setting/setting_dashboard/domain/entities/notification_setting_entity.dart';
import '../../../features/personal/setting/setting_dashboard/domain/entities/privacy_settings_entity.dart';
import '../../../features/personal/setting/setting_dashboard/domain/entities/time_away_entity.dart';
import '../../../features/personal/order/data/source/local/local_orders.dart';
import '../../../features/personal/user/profiles/data/sources/local/local_user.dart';
import '../../../features/personal/user/profiles/data/sources/local/local_visits.dart';
import '../../../features/personal/user/profiles/domain/entities/business_profile_detail_entity.dart';
import '../../../features/personal/order/domain/entities/order_entity.dart';
import '../../../features/personal/order/domain/entities/order_payment_detail_entity.dart';
import '../../../features/personal/user/profiles/domain/entities/supporter_detail_entity.dart';
import '../../../features/personal/user/profiles/domain/entities/user_stripe_account_entity.dart';
import '../../enums/cart/cart_item_type.dart';
import '../../enums/chat/chat_participant_role.dart';
import '../../enums/core/status_type.dart';
import '../../enums/listing/core/boolean_status_type.dart';
import '../../enums/listing/core/delivery_type.dart';
import '../../enums/listing/core/item_condition_type.dart';
import '../../enums/listing/core/listing_type.dart';
import '../../enums/listing/core/privacy_type.dart';
import '../../enums/message/message_type.dart';
import '../../enums/routine/day_type.dart';
import '../../widgets/phone_number/data/sources/local_country.dart';
import '../../widgets/phone_number/domain/entities/country_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'encryption_key_manager.dart';
import 'local_request_history.dart';

class HiveDB {
  static const String _encryptionMigratedKey = 'sellout_encryption_migrated_v1';

  static Future<void> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    await Hive.initFlutter();

    // Pre-initialize encryption key for encrypted boxes
    await EncryptionKeyManager.getEncryptionKey();

    // Handle migration from unencrypted to encrypted storage
    await _migrateToEncryptedStorage();

    // Hive
    Hive.registerAdapter(CurrentUserEntityAdapter()); // 0
    Hive.registerAdapter(UserEntityAdapter()); // 1
    // Hive.registerAdapter(MessageSenderTypeAdapter()); // 2
    Hive.registerAdapter(ApiRequestEntityAdapter()); // 3
    Hive.registerAdapter(AttachmentEntityAdapter()); // 4
    Hive.registerAdapter(AttachmentTypeAdapter()); // 5
    Hive.registerAdapter(AddressEntityAdapter()); // 6
    Hive.registerAdapter(ListingEntityAdapter()); // 7
    Hive.registerAdapter(SubCategoryEntityAdapter()); // 8
    Hive.registerAdapter(ListingTypeAdapter()); // 9
    Hive.registerAdapter(ChatEntityAdapter()); // 10
    Hive.registerAdapter(ChatParticipantEntityAdapter()); // 11
    Hive.registerAdapter(ChatParticipantRoleTypeAdapter()); // 12
    Hive.registerAdapter(MessageEntityAdapter()); // 13
    Hive.registerAdapter(VisitingEntityAdapter()); // 14
    // Hive.registerAdapter(VisitingPostEntityAdapter()); // 15
    Hive.registerAdapter(AvailabilityEntityAdapter()); // 16
    Hive.registerAdapter(LocationEntityAdapter()); // 17
    Hive.registerAdapter(MessageTypeAdapter()); // 18
    Hive.registerAdapter(OfferDetailEntityAdapter()); // 19
    Hive.registerAdapter(PostEntityAdapter()); // 20
    Hive.registerAdapter(DiscountEntityAdapter()); // 21
    Hive.registerAdapter(SizeColorEntityAdapter()); // 22
    Hive.registerAdapter(ColorEntityAdapter()); // 23
    Hive.registerAdapter(DeliveryTypeAdapter()); // 24
    Hive.registerAdapter(ConditionTypeAdapter()); // 25
    Hive.registerAdapter(PrivacyTypeAdapter()); // 26
    Hive.registerAdapter(OfferAmountInfoEntityAdapter()); // 27
    Hive.registerAdapter(ChatTypeAdapter()); // 28
    Hive.registerAdapter(GroupInfoEntityAdapter()); // 29
    Hive.registerAdapter(InvitationEntityAdapter()); // 30
    Hive.registerAdapter(BooleanStatusTypeAdapter()); // 31
    Hive.registerAdapter(DayTypeAdapter()); // 32
    Hive.registerAdapter(GettedMessageEntityAdapter()); // 33
    Hive.registerAdapter(MessageLastEvaluatedKeyEntityAdapter()); // 34
    Hive.registerAdapter(StatusTypeAdapter()); // 35
    Hive.registerAdapter(SupporterDetailEntityAdapter()); // 36
    Hive.registerAdapter(CartEntityAdapter()); // 37
    Hive.registerAdapter(CartItemEntityAdapter()); // 38
    Hive.registerAdapter(BusinessEntityAdapter()); // 39
    Hive.registerAdapter(BusinessTravelDetailEntityAdapter()); // 40
    Hive.registerAdapter(BusinessEmployeeEntityAdapter()); // 41
    Hive.registerAdapter(RoutineEntityAdapter()); // 42
    Hive.registerAdapter(BusinessAddressEntityAdapter()); // 43
    // Hive.registerAdapter(UserRoleInfoInBusinessEntityAdapter()); // 44
    Hive.registerAdapter(UserStripeAccountEntityAdapter()); // 45
    Hive.registerAdapter(ServiceEntityAdapter()); // 46
    Hive.registerAdapter(ReviewEntityAdapter()); // 47
    Hive.registerAdapter(ProfileBusinessDetailEntityAdapter()); // 48
    Hive.registerAdapter(BookingEntityAdapter()); // 49
    Hive.registerAdapter(BookingPaymentDetailEntityAdapter()); // 50
    Hive.registerAdapter(CountryEntityAdapter()); // 51
    Hive.registerAdapter(LoginDetailEntityAdapter()); // 52
    Hive.registerAdapter(ColorOptionEntityAdapter()); // 53
    Hive.registerAdapter(DeviceLoginInfoEntityAdapter()); // 54
    Hive.registerAdapter(UnreadMessageEntityAdapter()); // 55
    Hive.registerAdapter(PromoEntityAdapter()); // 56
    Hive.registerAdapter(NotificationSettingsEntityAdapter()); // 57
    Hive.registerAdapter(FeedEntityAdapter()); //60
    Hive.registerAdapter(OrderEntityAdapter()); //61
    Hive.registerAdapter(OrderPaymentDetailEntityAdapter()); //62
    Hive.registerAdapter(PrivacySettingsEntityAdapter()); //63
    Hive.registerAdapter(TimeAwayEntityAdapter()); //64
    Hive.registerAdapter(NotificationEntityAdapter()); //65
    Hive.registerAdapter(NotificationMetadataEntityAdapter()); //66
    Hive.registerAdapter(CounterOfferEnumAdapter()); //67
    Hive.registerAdapter(PostClothFootEntityAdapter()); //68
    Hive.registerAdapter(PostVehicleEntityAdapter()); //69
    Hive.registerAdapter(PostPetEntityAdapter()); //70
    Hive.registerAdapter(PostPropertyEntityAdapter()); //71
    Hive.registerAdapter(PostFoodDrinkEntityAdapter()); //72
    Hive.registerAdapter(PostItemEntityAdapter()); //73
    Hive.registerAdapter(PackageDetailEntityAdapter()); //75
    Hive.registerAdapter(ServiceCategoryEntityAdapter()); //76
    Hive.registerAdapter(ServiceTypeEntityAdapter()); //77
    Hive.registerAdapter(CategoriesEntityAdapter()); //78
    Hive.registerAdapter(DropdownOptionEntityAdapter()); //79
    Hive.registerAdapter(DropdownOptionDataEntityAdapter()); //80
    Hive.registerAdapter(ParentDropdownEntityAdapter()); //81
    Hive.registerAdapter(QuoteDetailEntityAdapter()); //82
    Hive.registerAdapter(ServiceEmployeeEntityAdapter()); //83
    Hive.registerAdapter(NumberFormatEntityAdapter()); //84
    Hive.registerAdapter(StateEntityAdapter()); //85
    Hive.registerAdapter(CartItemStatusTypeAdapter()); //86
    Hive.registerAdapter(MessagePostDetailEntityAdapter()); //87
    Hive.registerAdapter(StripeConnectAccountEntityAdapter()); //88
    Hive.registerAdapter(ShippingDetailEntityAdapter()); //89
    Hive.registerAdapter(PostageEntityAdapter()); //90
    Hive.registerAdapter(FastDeliveryEntityAdapter()); //91

    // Hive box Open
    await refresh();
  }

  static Future<void> refresh() async {
    await LocalAuth().refresh();
    await LocalPost().refresh();
    await LocalRequestHistory().refresh();
    await LocalUser().refresh();
    await LocalListing().refresh();
    await LocalChat().refresh();
    await LocalChatMessage().refresh();
    await LocalVisit().refresh();
    await LocalCart().refresh();
    await LocalBusiness().refresh();
    await LocalService().refresh();
    await LocalReview().refresh();
    await LocalBooking().refresh();
    await LocalCountry().refresh();
    await LocalUnreadMessagesService().refresh();
    await LocalPromo().refresh();
    await LocalCategoriesSource().refresh();
    await LocalColors().refresh();
    await LocalOrders().refresh();
    await LocalNotifications().refresh();
    await LocalServiceCategory().refresh();
  }

  static Future<void> signout() async {
    // Wrap each clear in try-catch to handle PathNotFoundException for lock files
    Future<void> safeClear(Future<void> Function() clearFn, String name) async {
      try {
        await clearFn();
      } catch (e) {
        debugPrint('HiveDB.signout: Error clearing $name: $e');
      }
    }

    await safeClear(() => LocalPost().clear(), 'LocalPost');
    await safeClear(() => LocalAuth().signout(), 'LocalAuth');
    await safeClear(() => LocalUser().clear(), 'LocalUser');
    await safeClear(() => LocalRequestHistory().clear(), 'LocalRequestHistory');
    await safeClear(() => LocalListing().clear(), 'LocalListing');
    await safeClear(() => LocalChat().clear(), 'LocalChat');
    await safeClear(() => LocalChatMessage().clear(), 'LocalChatMessage');
    await safeClear(() => LocalVisit().clear(), 'LocalVisit');
    await safeClear(() => LocalCart().clear(), 'LocalCart');
    await safeClear(() => LocalBusiness().clear(), 'LocalBusiness');
    await safeClear(() => LocalService().clear(), 'LocalService');
    await safeClear(() => LocalReview().clear(), 'LocalReview');
    await safeClear(() => LocalBooking().clear(), 'LocalBooking');
    await safeClear(() => LocalUnreadMessagesService().clear(),'LocalUnreadMessagesService');
    await safeClear(() => LocalPromo().clear(), 'LocalPromo');
    await safeClear(() => LocalColors().clear(), 'LocalColors');
    await safeClear(() => LocalOrders().clear(), 'LocalOrders');
    await safeClear(() => LocalNotifications().clear(), 'LocalNotifications');
    // await LocalServiceCategory().clear();
    // await LocalCategoriesSource().clear();
    // await LocalCountry().clear();
  }

  /// Migrates existing unencrypted data to encrypted storage.
  ///
  /// On first run after encryption is enabled, this clears old unencrypted
  /// boxes that will now use encryption. Users will need to re-login.
  static Future<void> _migrateToEncryptedStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool alreadyMigrated = prefs.getBool(_encryptionMigratedKey) ?? false;

    if (alreadyMigrated) return;

    debugPrint('HiveDB: Migrating to encrypted storage...');

    // Delete old unencrypted boxes that will now be encrypted
    // This ensures clean slate for encrypted boxes
    final List<String> boxesToMigrate = <String>[
      AppStrings.localAuthBox,
      AppStrings.localChatsBox,
      AppStrings.localChatMessagesBox,
      AppStrings.localOrdersBox,
      AppStrings.localCartBox,
      AppStrings.localUsersBox,
      AppStrings.localBookingsBox,
      AppStrings.localNotificationBox,
    ];

    for (final String boxName in boxesToMigrate) {
      try {
        if (Hive.isBoxOpen(boxName)) {
          await Hive.box(boxName).close();
        }
        await Hive.deleteBoxFromDisk(boxName);
        debugPrint('HiveDB: Deleted old unencrypted box: $boxName');
      } catch (e) {
        debugPrint('HiveDB: Error migrating box $boxName: $e');
      }
    }

    await prefs.setBool(_encryptionMigratedKey, true);
    debugPrint('HiveDB: Migration to encrypted storage complete');
  }
}
