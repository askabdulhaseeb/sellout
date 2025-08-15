import 'package:flutter/material.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../../attachment/domain/entities/picked_attachment_option.dart';
import '../../../../../attachment/views/screens/pickable_attachment_screen.dart';
import '../../../../dashboard/views/screens/dashboard_screen.dart';
import '../../../chat_dashboard/domain/entities/chat/chat_entity.dart';
import '../../../chat_dashboard/domain/params/create_chat_params.dart';
import '../../../chat_dashboard/domain/usecase/create_chat_usecase.dart';

class CreateChatGroupProvider with ChangeNotifier {
  CreateChatGroupProvider(
    this._createChatUsecase,
  );
  final CreateChatUsecase _createChatUsecase;
  //
  List<String> _selectedUserIds = <String>[];
  final TextEditingController _groupTitle = TextEditingController();
  final TextEditingController _groupDescription = TextEditingController();
  List<PickedAttachment> _attachments = <PickedAttachment>[];
  bool _isLoading = false;
  //
  List<String> get selectedUserIds => _selectedUserIds;
  TextEditingController get groupTitle => _groupTitle;
  TextEditingController get groupDescription => _groupDescription;
  List<PickedAttachment> get attachments => _attachments;
  bool get isLoading => _isLoading;
  //
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void toggleSupporter(String userId) {
    if (_selectedUserIds.contains(userId)) {
      _selectedUserIds.remove(userId);
    } else {
      _selectedUserIds.add(userId);
    }
    notifyListeners();
  }

  bool isSelected(String userId) {
    return _selectedUserIds.contains(userId);
  }

  void clearAll() {
    _selectedUserIds.clear();
    notifyListeners();
  }

  Future<void> setImages(
    BuildContext context, {
    required AttachmentType type,
  }) async {
    final List<PickedAttachment> selectedMedia = _attachments
        .where((PickedAttachment element) => element.selectedMedia != null)
        .toList();
    final List<PickedAttachment>? files =
        await Navigator.of(context).push<List<PickedAttachment>>(
      MaterialPageRoute<List<PickedAttachment>>(builder: (_) {
        return PickableAttachmentScreen(
          option: PickableAttachmentOption(
            maxAttachments: 1,
            allowMultiple: false,
            type: type,
            selectedMedia: selectedMedia
                .map((PickedAttachment e) => e.selectedMedia!)
                .toList(),
          ),
        );
      }),
    );

    if (files != null) {
      for (final PickedAttachment file in files) {
        final int existingIndex = _attachments.indexWhere(
          (PickedAttachment e) => e.selectedMedia?.id == file.selectedMedia?.id,
        );

        if (existingIndex != -1) {
          _attachments.removeAt(existingIndex);
        } else {
          _attachments.add(file);
        }
      }
      notifyListeners();
    }
  }

  void setAttachments(List<PickedAttachment> newAttachments) {
    attachments
      ..clear()
      ..addAll(newAttachments);
    notifyListeners();
  }

  Future<void> createChat(BuildContext context) async {
    setLoading(true);
    try {
      AppLog.info('Creating chat', name: 'CreateChatGroupProvider.createChat');

      final CreateChatParams params = CreateChatParams(
        attachments: attachments,
        groupDescription: groupDescription.text.trim(),
        groupTitle: groupTitle.text.trim(),
        recieverId: _selectedUserIds,
        type: ChatType.group.json,
      );
      debugPrint('CreateChatParams: ${params.toMap()}');
      final DataState<ChatEntity> result =
          await _createChatUsecase.call(params);
      if (result is DataSuccess<ChatEntity>) {
        setLoading(false);

        AppNavigator.pushNamedAndRemoveUntil(
          DashboardScreen.routeName,
          (_) => false,
        );
      } else {
        setLoading(false);
        AppLog.error(
          'Failed to create group chat',
          name: 'CreateChatGroupProvider.createChat - else',
          error: result.exception,
        );
      }
    } catch (e, stc) {
      AppLog.error('Exception occurred while creating group chat',
          name: 'CreateChatGroupProvider.createChat - catch',
          error: CustomException(e.toString()),
          stackTrace: stc);
    } finally {
      setLoading(false);
    }
  }

  void reset() {
    _selectedUserIds = <String>[];
    _groupTitle.text = '';
    _groupDescription.text = '';
    _attachments = <PickedAttachment>[];
    setLoading(false);
  }
}
