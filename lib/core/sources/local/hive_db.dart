import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../../features/attachment/domain/entities/attachment_entity.dart';
import '../../../features/personal/cart/data/sources/local_cart.dart';
import '../../../features/personal/cart/domain/entities/cart_entity.dart';
import '../../../features/personal/chats/chat/data/sources/local/local_message.dart';
import '../../../features/personal/chats/chat/domain/entities/getted_message_entity.dart';
import '../../../features/personal/chats/chat/domain/entities/message_last_evaluated_key_entity.dart';
import '../../../features/personal/chats/chat_dashboard/data/sources/local/local_chat.dart';
import '../../../features/personal/chats/chat_dashboard/domain/entities/chat/chat_entity.dart';
import '../../../features/personal/chats/chat_dashboard/domain/entities/chat/group/group_into_entity.dart';
import '../../../features/personal/chats/chat_dashboard/domain/entities/chat/participant/chat_participant_entity.dart';
import '../../../features/personal/chats/chat_dashboard/domain/entities/chat/participant/invitation_entity.dart';
import '../../../features/personal/chats/chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../features/personal/listing/listing_form/data/sources/local/local_listing.dart';
import '../../../features/personal/listing/listing_form/domain/entities/listing_entity.dart';
import '../../../features/personal/listing/listing_form/domain/entities/sub_category_entity.dart';
import '../../../features/personal/auth/signin/data/models/address_model.dart';
import '../../../features/personal/auth/signin/data/sources/local/local_auth.dart';
import '../../../features/personal/location/domain/entities/location_entity.dart';
import '../../../features/personal/post/data/sources/local/local_post.dart';
import '../../../features/personal/post/domain/entities/meetup/availability_entity.dart';
import '../../../features/personal/post/domain/entities/offer/offer_amount_info_entity.dart';
import '../../../features/personal/post/domain/entities/offer/offer_detail_entity.dart';
import '../../../features/personal/post/domain/entities/post_entity.dart';
import '../../../features/personal/post/domain/entities/size_color/color_entity.dart';
import '../../../features/personal/post/domain/entities/size_color/discount_entity.dart';
import '../../../features/personal/post/domain/entities/size_color/size_color_entity.dart';
import '../../../features/personal/post/domain/entities/visit/visiting_entity.dart';
import '../../../features/personal/user/profiles/data/sources/local/local_user.dart';
import '../../../features/personal/user/profiles/data/sources/local/local_visits.dart';
import '../../../features/personal/user/profiles/domain/entities/supporter_detail_entity.dart';
import '../../enums/chat/chat_participant_role.dart';
import '../../enums/core/status_type.dart';
import '../../enums/listing/core/boolean_status_type.dart';
import '../../enums/listing/core/delivery_type.dart';
import '../../enums/listing/core/item_condition_type.dart';
import '../../enums/listing/core/listing_type.dart';
import '../../enums/listing/core/privacy_type.dart';
import '../../enums/message/message_type.dart';
import '../../enums/routine/day_type.dart';
import 'local_request_history.dart';

class HiveDB {
  static Future<void> init() async {
    // await LocalState.init();
    Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    await Hive.initFlutter();

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
    // Hive box Open
    await refresh();
  }

  static Future<void> refresh() async {
    await LocalPost().refresh();
    await LocalAuth().refresh();
    await LocalUser().refresh();
    await LocalRequestHistory().refresh();
    await LocalListing().refresh();
    await LocalChat().refresh();
    await LocalChatMessage().refresh();
    await LocalVisit().refresh();
    await LocalCart().refresh();
  }
}
