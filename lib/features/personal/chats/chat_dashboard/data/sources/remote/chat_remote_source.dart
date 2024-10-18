import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';

import '../../../../../../../core/sources/api_call.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../models/chat/chat_model.dart';
import '../local/local_chat.dart';

abstract interface class ChatRemoteSource {
  Future<DataState<List<ChatModel>>> getChats(List<String>? params);
}

class ChatRemoteSourceImpl implements ChatRemoteSource {
  @override
  Future<DataState<List<ChatModel>>> getChats(List<String>? params) async {
    final List<String> chatIDs =
        params ?? LocalAuth.currentUser?.chatIDs ?? <String>[];
    if (chatIDs.isEmpty) {
      return DataFailer<List<ChatModel>>(CustomException('no-chats'.tr()));
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
          return DataFailer<List<ChatModel>>(
              CustomException('something-wrong'.tr()));
        }
        final dynamic mapp = json.decode(rawData);
        final List<dynamic> data = mapp['chats'] as List<dynamic>;

        log('⚡️ Raw Chats: ${data.length}');
        final List<ChatModel> chats = <ChatModel>[];
        for (final dynamic element in data) {
          final ChatModel chat = ChatModel.fromJson(element);
          chats.add(chat);
          await LocalChat().save(chat);
        }
        log('⚡️ Chats: ${chats.length}');
        return DataSuccess<List<ChatModel>>(rawData, chats);
      } else {
        return DataFailer<List<ChatModel>>(
            result.exception ?? CustomException('something-wrong'.tr()));
      }
    } catch (e) {
      return DataFailer<List<ChatModel>>(CustomException('$e'));
    }
  }
}
