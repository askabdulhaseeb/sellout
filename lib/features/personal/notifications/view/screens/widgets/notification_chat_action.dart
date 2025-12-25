import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../chats/chat/views/providers/chat_provider.dart';

class NotificationChatAction {
  const NotificationChatAction._();

  static Future<void> navigate({
    required BuildContext context,
    required String? chatId,
  }) async {
    if (chatId == null || chatId.trim().isEmpty) {
      if (context.mounted) {
        AppSnackBar.showSnackBar(context, 'chat_not_found'.tr());
      }
      return;
    }

    if (context.mounted) {
      final ChatProvider chatProvider = context.read<ChatProvider>();
      await chatProvider.createOrOpenChatById(context, chatId);
    }
  }

  static String getButtonText() => 'chat'.tr();
}
