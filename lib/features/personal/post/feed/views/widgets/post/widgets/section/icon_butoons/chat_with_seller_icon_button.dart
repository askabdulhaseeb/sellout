import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../../../../core/widgets/custom_svg_icon.dart';
import '../../../../../../../../chats/create_chat/view/provider/create_private_chat_provider.dart';

class ChatwithSellerIconButton extends StatelessWidget {
  const ChatwithSellerIconButton({
    required this.userId,
    super.key,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    final bool isLoading =
        Provider.of<CreatePrivateChatProvider>(context).isLoading;

    return InkWell(
      onTap: isLoading
          ? null
          : () {
              Provider.of<CreatePrivateChatProvider>(context, listen: false)
                  .startPrivateChat(context, userId);
            },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : CustomSvgIcon(
                assetPath: AppStrings.selloutOrderChatIcon,
                color: ColorScheme.of(context).onSurface,
              ),
      ),
    );
  }
}
