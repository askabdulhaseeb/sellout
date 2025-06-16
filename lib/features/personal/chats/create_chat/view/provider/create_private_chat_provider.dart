import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../dashboard/views/screens/dashboard_screen.dart';
import '../../../chat/views/providers/chat_provider.dart';
import '../../../chat/views/screens/chat_screen.dart';
import '../../../chat_dashboard/data/models/chat/chat_model.dart';
import '../../../chat_dashboard/domain/entities/chat/chat_entity.dart';
import '../../../chat_dashboard/domain/params/create_chat_params.dart';
import '../../../chat_dashboard/domain/usecase/create_chat_usecase.dart';

class CreatePrivateChatProvider with ChangeNotifier {
  CreatePrivateChatProvider(
    this._createChatUsecase,
  );
  final CreateChatUsecase _createChatUsecase;
  //
  bool _isLoading = false;
  List<String> _selectedUserIds = <String>[];

  //
  bool get isLoading => _isLoading;
  List<String> get selectedUserIds => _selectedUserIds;

  //
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setSelectedUserId(String id) {
    _selectedUserIds = <String>[id];
    notifyListeners();
  }

  void startPrivateChat(BuildContext context, String userId) {
    setSelectedUserId(userId);
    createChat(context);
  }

  //
  Future<void> createChat(BuildContext context) async {
    setLoading(true);
    try {
      AppLog.info('Creating chat',
          name: 'CreatePrivateChatProvider.createChat');

      final CreateChatParams params = CreateChatParams(
        recieverId: _selectedUserIds,
        type: ChatType.private.json,
      );
      debugPrint('CreateChatParams: ${params.toMap()}');
      final DataState<ChatEntity> result =
          await _createChatUsecase.call(params);
      if (result is DataSuccess<ChatEntity>) {
        setLoading(false);
        debugPrint(result.data ?? '');
        final Map<String, dynamic> chat = jsonDecode(result.data ?? '');
        final ChatModel chatEntity = ChatModel.fromJson(chat['data']);
        await Provider.of<ChatProvider>(context, listen: false)
            .openChat(context, chatEntity);
      } else {
        setLoading(false);
        AppLog.error(
          'Failed to create private chat',
          name: 'CreatePrivateChatProvider.createChat - else',
          error: result.exception,
        );
      }
    } catch (e, stc) {
      AppLog.error('Exception occurred while creating private chat',
          name: 'CreatePrivateChatProvider.createChat - catch',
          error: CustomException(e.toString()),
          stackTrace: stc);
    } finally {
      setLoading(false);
    }
  }
}
