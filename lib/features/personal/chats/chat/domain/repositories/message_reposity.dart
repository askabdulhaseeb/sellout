import '../../../../../../core/sources/data_state.dart';
import '../../../../post/domain/params/share_in_chat_params.dart';
import '../entities/getted_message_entity.dart';
import '../params/leave_group_params.dart';
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
}
