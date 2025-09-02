import '../../../../../../core/sources/data_state.dart';
import '../../../../post/data/sources/remote/offer_remote_api.dart';
import '../../../../post/domain/params/offer_payment_params.dart';
import '../../../../post/domain/params/share_in_chat_params.dart';
import '../../../../post/domain/params/update_offer_params.dart';
import '../../domain/entities/getted_message_entity.dart';
import '../../domain/params/leave_group_params.dart';
import '../../domain/params/send_invite_to_group_params.dart';
import '../../domain/params/send_message_param.dart';
import '../../domain/repositories/message_reposity.dart';
import '../sources/remote/messages_remote_source.dart';

class MessageRepositoryImpl implements MessageRepository {
  const MessageRepositoryImpl(this.remoteSource, this.offerRemoteApi);
  final MessagesRemoteSource remoteSource;
  final OfferRemoteApi offerRemoteApi;
  @override
  Future<DataState<GettedMessageEntity>> getMessages({
    required String chatID,
    required String? key,
    required String createdAt,
  }) async {
    return await remoteSource.getMessages(
      chatID: chatID,
      key: key,
      createdAt: createdAt,
    );
  }

  @override
  Future<DataState<bool>> sendMessage(SendMessageParam msg) async {
    return await remoteSource.sendMessage(msg);
  }

  @override
  Future<DataState<bool>> acceptGorupInvite(String groupId) async {
    return await remoteSource.acceptGorupInvite(groupId);
  }

  @override
  Future<DataState<bool>> removeParticipants(LeaveGroupParams params) async {
    return await remoteSource.removeParticipants(params);
  }

  @override
  Future<DataState<bool>> sendInviteToGroup(
      SendGroupInviteParams params) async {
    return await remoteSource.sendInviteToGroup(params);
  }

  @override
  Future<DataState<bool>> sharePostToChat(ShareInChatParams params) async {
    return await remoteSource.sharePostToChat(params);
  }

  @override
  Future<DataState<bool>> updateOffer(UpdateOfferParams param) async {
    return await offerRemoteApi.updateOffer(param);
  }

  @override
  Future<DataState<String>> offerPayment(OfferPaymentParams param) async {
    return await offerRemoteApi.offerPayment(param);
  }
}
