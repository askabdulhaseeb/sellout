import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import '../../../../../../../core/enums/chat/chat_participant_role.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sources/api_call.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../post/domain/params/share_in_chat_params.dart';
import '../../../../chat_dashboard/data/models/chat/chat_model.dart';
import '../../../../chat_dashboard/data/models/chat/participant/chat_participant_model.dart';
import '../../../../chat_dashboard/data/models/message/message_model.dart';
import '../../../../chat_dashboard/data/sources/local/local_chat.dart';
import '../../../../chat_dashboard/domain/entities/chat/participant/chat_participant_entity.dart';
import '../../../../chat_dashboard/domain/entities/chat/participant/invitation_entity.dart';
import '../../../domain/entities/getted_message_entity.dart';
import '../../../domain/params/leave_group_params.dart';
import '../../../domain/params/post_inquiry_params.dart';
import '../../../domain/params/send_invite_to_group_params.dart';
import '../../../domain/params/send_message_param.dart';
import '../../models/getted_message_model.dart';
import '../local/local_message.dart';

abstract interface class MessagesRemoteSource {
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
  Future<DataState<bool>> createPostInquiry(PostInquiryParams params);
}

class MessagesRemoteSourceImpl implements MessagesRemoteSource {
  @override
  Future<DataState<GettedMessageEntity>> getMessages({
    required String chatID,
    required String? key,
    required String createdAt,
  }) async {
    String endpoint =
        '''/chat/getMessages/$chatID?lastEvaluatedKey={"chat_id":"$chatID","message_id":"$key","created_at":"$createdAt"}''';
    final DataState<bool> result = await ApiCall<bool>().call(
      endpoint: endpoint,
      isAuth: true,
      requestType: ApiRequestType.get,
    );
    if (result is DataSuccess) {
      final String raw = result.data ?? '';
      if (raw.isEmpty) {
        AppLog.info(
          'New Message - Empty',
          name: 'MessagesRemoteSourceImpl.getMessages - if',
        );
        return DataSuccess<GettedMessageEntity>(raw, _local(chatID));
      }
      //
      final dynamic data = json.decode(raw);
      final GettedMessageEntity getted = GettedMessageModel.fromMap(
        data,
        chatID,
      );
      await LocalChatMessage().save(chatID,getted);
      return DataSuccess<GettedMessageEntity>(result.data ?? '', getted);
    } else {
      AppLog.error(
        'New Message - ERROR',
        name: 'MessagesRemoteSourceImpl.getMessages - else',
        error: result.exception,
      );
      final GettedMessageEntity? getted = _local(chatID);
      return getted == null
          ? DataSuccess<GettedMessageEntity>(result.data ?? '', getted)
          : DataFailer<GettedMessageEntity>(
              result.exception ?? CustomException('something_wrong'.tr()),
            );
    }
  }

  @override
  Future<DataState<bool>> sendMessage(SendMessageParam msg) async {
    try {
      const String endpoint = '/chat/message/send';
      final Map<String, String> body = msg.fieldMap();

      final DataState<bool> result = await ApiCall<bool>().callFormData(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        fieldsMap: body,
        attachments: msg.files,
        isConnectType: false,
      );

      if (result is DataSuccess) {
        final Map<String, dynamic> responseData = jsonDecode(result.data ?? '');
        final Map<String, dynamic> data = responseData['items'];
        final MessageModel newMsg = MessageModel.fromMap(data);
        final String chatId = data['chat_id'];
        await LocalChatMessage().saveMessage(newMsg);
        AppLog.info(
          '📤 Message sent & saved locally | chatId: $chatId | messageId: ${newMsg.messageId}',
          name: 'MessagesRemoteSourceImpl.sendMessage',
        );
        return DataSuccess<bool>(result.data ?? '', true);
      } else {
        AppLog.error(
          '🚫 Message send failed from server',
          name: 'MessagesRemoteSourceImpl.sendMessage - else',
          error: result.exception,
        );
        return DataFailer<bool>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e) {
      AppLog.error(
        ' Message send crashed',
        name: 'MessagesRemoteSourceImpl.sendMessage - catch',
        error: CustomException(e.toString()),
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<bool>> acceptGorupInvite(String groupId) async {
    try {
      const String endpoint = '/chat/group/acceptInvite';
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.patch,
        body: jsonEncode(<String, String>{'chat_id': groupId}),
      );

      if (result is DataSuccess) {
        debugPrint('Invite Accepted - Success: ${result.data}');
        final Map<String, dynamic> responseData = jsonDecode(
          result.data ?? '{}',
        );
        final DateTime joinAt = DateTime.parse(responseData['join_at']);
        final String uid = LocalAuth.uid ?? '';
        final ChatEntity? chat = LocalChat().chatEntity(groupId);
        if (chat != null) {
          final List<InvitationEntity>? invitations =
              chat.groupInfo?.invitations;
          final List<ChatParticipantEntity>? participants =
              chat.groupInfo?.participants;
          if (invitations != null && participants != null) {
            final int inviteIndex = invitations.indexWhere(
              (InvitationEntity p) => p.uid == uid,
            );
            if (inviteIndex != -1) {
              final InvitationEntity invite = invitations[inviteIndex];
              // ✅ Convert invitation to participant
              final ChatParticipantModel participant = ChatParticipantModel(
                chatAt: joinAt,
                uid: invite.uid,
                addedBy: invite.addedBy,
                joinAt: joinAt,
                role: ChatParticipantRoleType.member,
                source: 'invitation',
              );

              // ✅ Add participant to participants list
              participants.add(participant);

              // ✅ Remove invitation from invitations list
              invitations.removeAt(inviteIndex);

              // ✅ Save updated chat to Hive
              final Box<ChatEntity> box = Hive.box<ChatEntity>(
                AppStrings.localChatsBox,
              );
              box.put(chat.chatId, chat);
            }
          }
        }

        return DataSuccess<bool>(result.data ?? '', true);
      } else {
        AppLog.error(
          'Invite Accept - ERROR',
          name: 'MessagesRemoteSourceImpl.acceptGorupInvite - else',
          error: result.exception,
        );
        return DataFailer<bool>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e) {
      AppLog.error(
        'Invite Accept - ERROR',
        name: 'MessagesRemoteSourceImpl.acceptGorupInvite - catch',
        error: CustomException(e.toString()),
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<bool>> removeParticipants(LeaveGroupParams params) async {
    try {
      const String endpoint = '/chat/group/removal';
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.patch,
        body: jsonEncode(params.toMap()),
      );
      if (result is DataSuccess) {
        debugPrint('Group Leave/remove - Success: ${result.data}');
        // final Map<String, dynamic> responseData = jsonDecode(result.data ?? '{}');
        // final DateTime joinAt = DateTime.parse(responseData['join_at']);
        final String uid = params.participantId ?? '';
        final ChatEntity? chat = LocalChat().chatEntity(params.chatId);
        if (chat != null) {
          final List<ChatParticipantEntity>? participants =
              chat.groupInfo?.participants;
          if (participants != null) {
            final int inviteIndex = participants.indexWhere(
              (ChatParticipantEntity p) => p.uid == uid,
            );
            participants.removeAt(inviteIndex);
            final Box<ChatEntity> box = Hive.box<ChatEntity>(
              AppStrings.localChatsBox,
            );
            box.put(chat.chatId, chat);
          }
        }
        return DataSuccess<bool>(result.data ?? '', true);
      } else {
        AppLog.error(
          'Invite Accept - ERROR',
          name: 'MessagesRemoteSourceImpl.removeParticipants - else',
          error: result.exception,
        );
        return DataFailer<bool>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e) {
      AppLog.error(
        'Invite Accept - ERROR',
        name: 'MessagesRemoteSourceImpl.removeParticipants - catch',
        error: CustomException(e.toString()),
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<bool>> sendInviteToGroup(
    SendGroupInviteParams params,
  ) async {
    try {
      debugPrint(jsonEncode(params.toMap()));
      const String endpoint = '/chat/group/add';
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.patch,
        body: jsonEncode(params.toMap()),
      );

      if (result is DataSuccess) {
        debugPrint('Group Invite sent - Success: ${result.data}');
        return DataSuccess<bool>(result.data ?? '', true);
      } else {
        AppLog.error(
          'Invite send error - ERROR',
          name: 'MessagesRemoteSourceImpl.sendInviteToGroup - else',
          error: result.exception,
        );
        return DataFailer<bool>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e, stc) {
      AppLog.error(
        'Invite send error - ERROR',
        name: 'MessagesRemoteSourceImpl.sendInviteToGroup - catch',
        error: CustomException(e.toString()),
        stackTrace: stc,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<bool>> sharePostToChat(ShareInChatParams params) async {
    try {
      final String endpoint = '/chat/share/${params.endPointChatType}';
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        body: jsonEncode(params.toMap()),
      );

      if (result is DataSuccess) {
        debugPrint('✅ [sharePostToChat] Share success: ${result.data}');
        return DataSuccess<bool>(result.data ?? '', true);
      } else {
        AppLog.error(
          'Failed to share post to chat. Params: ${params.toMap()}',
          name: 'MessagesRemoteSourceImpl.sharePostToChat → else',
          error: result.exception?.message,
        );
        return DataFailer<bool>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e, stc) {
      AppLog.error(
        'Exception occurred while sharing post to chat.',
        name: 'MessagesRemoteSourceImpl.sharePostToChat → Exception',
        error: e.toString(),
        stackTrace: stc,
      );
      return DataFailer<bool>(CustomException('something_wrong'.tr()));
    }
  }

  @override
  Future<DataState<bool>> createPostInquiry(PostInquiryParams params) async {
    try {
      const String endpoint = '/chat/post/inquiry';
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        isAuth: true,
        body: jsonEncode(params.toJson()),
      );

      if (result is DataSuccess) {
        AppLog.info(
          'Post inquiry created successfully',
          name: 'MessagesRemoteSourceImpl.createPostInquiry - success',
        );
        debugPrint('✅ [createPostInquiry] Inquiry created: ${result.data}');
        return DataSuccess<bool>(result.data ?? '', true);
      } else {
        AppLog.error(
          'Failed to create post inquiry',
          name: 'MessagesRemoteSourceImpl.createPostInquiry - failed',
          error: result.exception,
        );
        return DataFailer<bool>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e, stk) {
      AppLog.error(
        'Exception while creating post inquiry',
        name: 'MessagesRemoteSourceImpl.createPostInquiry - catch',
        error: e.toString(),
        stackTrace: stk,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  GettedMessageEntity? _local(String chatID) {
    return LocalChatMessage().entity(chatID);
  }
}
