import '../../../../../../core/sources/data_state.dart';
import '../../../../../postage/data/models/postage_detail_repsonse_model.dart';
import '../../../../post/domain/params/offer_payment_params.dart';
import '../../../../post/domain/params/share_in_chat_params.dart';
import '../../../../post/domain/params/update_offer_params.dart';
import '../../../../post/domain/entities/offer/offer_payment_response.dart';
import '../../../../post/domain/params/buy_now_add_shipping_param.dart';
import '../../../../post/domain/params/buy_now_shipping_rates_params.dart';
import '../../../../basket/data/models/cart/buynow_add_shipping_response_model.dart';
import '../entities/getted_message_entity.dart';
import '../params/leave_group_params.dart';
import '../params/post_inquiry_params.dart';
import '../params/send_invite_to_group_params.dart';
import '../params/send_message_param.dart';

abstract interface class MessageRepository {
  Future<DataState<GettedMessageEntity>> getMessages({
    required String chatID,
    required String? key,
    required String createdAt,
  });
  Future<DataState<bool>> sendMessage(SendMessageParam msg);
  Future<DataState<bool>> acceptGorupInvite(String groupId);
  Future<DataState<bool>> removeParticipants(LeaveGroupParams params);
  Future<DataState<bool>> sendInviteToGroup(SendGroupInviteParams params);
  Future<DataState<bool>> sharePostToChat(ShareInChatParams params);
  Future<DataState<bool>> updateOffer(UpdateOfferParams param);
  Future<DataState<OfferPaymentResponse>> offerPayment(
    OfferPaymentParams param,
  );
  Future<DataState<PostageDetailResponseModel>> getBuyNowShippingRates(
    BuyNowShippingRatesParams param,
  );
  Future<DataState<BuyNowAddShippingResponseModel>> addBuyNowShipping(
    BuyNowAddShippingParam param,
  );
  Future<DataState<bool>> createPostInquiry(PostInquiryParams params);
}
