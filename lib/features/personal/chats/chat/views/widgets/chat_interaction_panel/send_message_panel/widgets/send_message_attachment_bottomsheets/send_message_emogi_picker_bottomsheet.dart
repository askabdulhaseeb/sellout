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
        enableDrag: false,
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

// 👇 This is private and only used inside this file
class _EmojiPickerBottomSheet extends StatelessWidget {
  const _EmojiPickerBottomSheet();

  @override
  Widget build(BuildContext context) {
    final SendMessageProvider chatPro =
        Provider.of<SendMessageProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: Container(
        height: 450,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: EmojiPicker(
          onBackspacePressed: () {},
          textEditingController: chatPro.message,
          config: Config(
            height: 260,
            checkPlatformCompatibility: true,
            emojiViewConfig: EmojiViewConfig(
              emojiSizeMax: 20,
              backgroundColor: Theme.of(context).cardColor,
            ),
            viewOrderConfig: const ViewOrderConfig(
              top: EmojiPickerItem.categoryBar,
              middle: EmojiPickerItem.emojiView,
              bottom: EmojiPickerItem.searchBar,
            ),
            skinToneConfig: const SkinToneConfig(),
            categoryViewConfig: CategoryViewConfig(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            bottomActionBarConfig: BottomActionBarConfig(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            searchViewConfig: SearchViewConfig(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
