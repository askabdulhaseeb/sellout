import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../../../../core/widgets/custom_svg_icon.dart';
import '../../../../../providers/send_message_provider.dart';

class EmojiPickerIconButton extends StatelessWidget {
  const EmojiPickerIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModalBottomSheet(
        isDismissible: true,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (_) => const _EmojiPickerBottomSheet(),
      ),
      child: const Padding(
        padding: EdgeInsets.all(6),
        child: CustomSvgIcon(assetPath: AppStrings.selloutChatEmogiIcon),
      ),
    );
  }
}

// Private bottom sheet widget
class _EmojiPickerBottomSheet extends StatelessWidget {
  const _EmojiPickerBottomSheet();

  @override
  Widget build(BuildContext context) {
    final SendMessageProvider chatPro =
        Provider.of<SendMessageProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: EmojiPicker(
        onBackspacePressed: () {},
        textEditingController: chatPro.message,
        config: Config(
          checkPlatformCompatibility: true,
          // emojiSizeMax: 28,
          // backgroundColor: Theme.of(context).cardColor,
          emojiViewConfig: EmojiViewConfig(
            backgroundColor: Theme.of(context).cardColor,
            emojiSizeMax: 28,
          ),
          viewOrderConfig: const ViewOrderConfig(
            top: EmojiPickerItem.categoryBar,
            middle: EmojiPickerItem.emojiView,
            bottom: EmojiPickerItem.searchBar,
          ),
          categoryViewConfig: CategoryViewConfig(
            backgroundColor: Theme.of(context).cardColor,
          ),
          bottomActionBarConfig: BottomActionBarConfig(
            backgroundColor: Theme.of(context).cardColor,
          ),
          searchViewConfig: SearchViewConfig(
            backgroundColor: Theme.of(context).cardColor,
          ),
        ),
      ),
    );
  }
}
