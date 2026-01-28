import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/widgets/buttons/custom_icon_button.dart';
import '../../../../../../../core/widgets/utils/app_snackbar.dart';
import '../../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../../user/profiles/views/user_profile/widgets/bottomsheets/block_user_bottomsheet.dart';
import '../../../../../user/profiles/views/user_profile/widgets/bottomsheets/unblock_user_bottomsheet.dart';
import '../../../../chat_dashboard/data/sources/local/local_unseen_messages.dart';
import '../../../../chat_dashboard/domain/entities/chat/chat_entity.dart';
import '../../providers/chat_provider.dart';
import 'group_chat_title_widget.dart';
import 'private_chat_title_widget.dart';
import 'product_chat_title_widget.dart';

AppBar chatAppBar(BuildContext context) {
  final ChatProvider chatProvider = Provider.of<ChatProvider>(context);
  final ChatEntity? chat = chatProvider.chat;
  final bool isGroup = chat?.type == ChatType.group;
  final bool showBlockMenu = !isGroup && chatProvider.otherUserId != null;
  return AppBar(
    automaticallyImplyLeading: false,
    titleSpacing: 0,
    title: Row(
      children: <Widget>[
        CustomIconButton(
          bgColor: Colors.transparent,
          padding: const EdgeInsets.all(6),
          icon: Icons.arrow_back_ios_new_rounded,
          iconSize: 16,
          onPressed: () {
            Navigator.pop(context);
            LocalUnreadMessagesService().clearCount(chat?.chatId ?? '');
          },
        ),
        Expanded(
          child: chat?.productInfo?.type == ChatType.product
              ? const ProductChatTitleWidget()
              : chat?.productInfo?.type == ChatType.service
              ? const PrivateChatTitleWidget()
              : chat?.type == ChatType.group
              ? const GroupChatTitleWidget()
              : const PrivateChatTitleWidget(),
        ),
      ],
    ),
    actions: <Widget>[
      if (showBlockMenu)
        PopupMenuButton<int>(
          onSelected: (int value) async {
            if (value != 0 || chatProvider.isBlockingBusy) return;

            final bool willBlock = !chatProvider.isOtherUserBlocked;
            final String? otherUserId = chatProvider.otherUserId;
            final String displayName = otherUserId != null
                ? LocalUser().userEntity(otherUserId)?.displayName ??
                      'this_user'.tr()
                : 'this_user'.tr();

            final bool? confirmed = willBlock
                ? await showBlockUserBottomSheet(context, name: displayName)
                : await showUnblockUserBottomSheet(context, name: displayName);

            if (confirmed != true) return;

            final DataState<bool?> result = await chatProvider.toggleBlockPeer(
              block: willBlock,
            );

            if (!context.mounted) return;

            if (result is DataSuccess<bool?>) {
              AppSnackBar.showSnackBar(
                context,
                chatProvider.isOtherUserBlocked
                    ? 'user_blocked_successfully'.tr()
                    : 'user_unblocked_successfully'.tr(),
              );
            } else {
              AppSnackBar.showSnackBar(
                context,
                result.exception?.message ?? 'something_wrong'.tr(),
              );
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
            PopupMenuItem<int>(
              value: 0,
              child: chatProvider.isBlockingBusy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      chatProvider.isOtherUserBlocked
                          ? 'unblock_user'.tr()
                          : 'block_user'.tr(),
                    ),
            ),
          ],
        ),
    ],
  );
}
