import 'package:easy_localization/easy_localization.dart';

import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sources/api_call.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../domain/params/create_private_chat_params.dart';
import '../../models/chat/chat_model.dart';
import '../local/local_chat.dart';

abstract interface class ChatRemoteSource {
  Future<DataState<List<ChatEntity>>> getChats(List<String>? params);
  Future<DataState<ChatEntity>> createPrivateChat(
      CreatePrivateChatParams params);
}

class ChatRemoteSourceImpl implements ChatRemoteSource {
  @override
  Future<DataState<List<ChatEntity>>> getChats(List<String>? params) async {
    final List<String> chatIDs =
        params ?? LocalAuth.currentUser?.chatIDs ?? <String>[];
    if (chatIDs.isEmpty) {
      return DataFailer<List<ChatEntity>>(CustomException('no_chats'.tr()));
    }
    try {
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: '/chat',
        requestType: ApiRequestType.post,
        isAuth: true,
        body: json.encode(<String, dynamic>{'chat_ids': chatIDs}),
      );

      if (result is DataSuccess<bool>) {
        final String rawData = result.data ?? '';
        if (rawData.isEmpty) {
          return DataFailer<List<ChatEntity>>(
              CustomException('something_wrong'.tr()));
        }
        final dynamic mapp = json.decode(rawData);
        final List<dynamic> data = mapp['chats'] as List<dynamic>;
        //
        final List<ChatEntity> chats = <ChatEntity>[];
        for (final dynamic element in data) {
          final ChatEntity chat = ChatModel.fromJson(element);
          chats.add(chat);
          await LocalChat().save(chat);
        }
        return DataSuccess<List<ChatEntity>>(rawData, chats);
      } else {
        return DataFailer<List<ChatEntity>>(
            result.exception ?? CustomException('something_wrong'.tr()));
      }
    } catch (e) {
      return DataFailer<List<ChatEntity>>(CustomException('$e'));
    }
  }

  @override
  Future<DataState<ChatEntity>> createPrivateChat(
      CreatePrivateChatParams params) async {
    try {
      const String endpoint = '/chat/create';

      final DataState<ChatEntity> result = await ApiCall<ChatEntity>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        body: '',
      );

      if (result is DataSuccess) {
        return DataSuccess<ChatEntity>(result.data ?? '', result.entity);
      } else {
        AppLog.error(
          'New Message - ERROR',
          name: 'ChatRemoteSourceImpl.createPrivateChat - else',
          error: result.exception,
        );
        return DataFailer<ChatEntity>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e) {
      AppLog.error(
        'New Message - ERROR',
        name: 'ChatRemoteSourceImpl.createPrivateChat - catch',
        error: CustomException(e.toString()),
      );
      return DataFailer<ChatEntity>(CustomException(e.toString()));
    }
  }
}
