import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../../../../core/widgets/custom_svg_icon.dart';
import '../../../../../providers/send_message_provider.dart';

/// Button to toggle the inline emoji picker
class EmojiPickerIconButton extends StatelessWidget {
  const EmojiPickerIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final SendMessageProvider msgPro =
        Provider.of<SendMessageProvider>(context, listen: false);

    return ValueListenableBuilder<bool>(
      valueListenable: msgPro.isEmojiPickerOpen,
      builder: (BuildContext context, bool isOpen, Widget? child) {
        return InkWell(
          onTap: () {
            if (isOpen) {
              // Close emoji picker and show keyboard
              msgPro.closeEmojiPicker(focusTextField: true);
            } else {
              // Open emoji picker (this also dismisses keyboard)
              msgPro.openEmojiPicker();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isOpen
                  ? Icon(
                      Icons.keyboard,
                      key: const ValueKey<String>('keyboard'),
                      color: Theme.of(context).iconTheme.color,
                      size: 24,
                    )
                  : const CustomSvgIcon(
                      key: ValueKey<String>('emoji'),
                      assetPath: AppStrings.selloutChatEmogiIcon,
                    ),
            ),
          ),
        );
      },
    );
  }
}

/// Inline emoji picker widget that appears below the text field
class InlineEmojiPicker extends StatelessWidget {
  const InlineEmojiPicker({super.key});

  static const double _pickerHeight = 250.0;

  @override
  Widget build(BuildContext context) {
    final SendMessageProvider msgPro =
        Provider.of<SendMessageProvider>(context, listen: false);

    return ValueListenableBuilder<bool>(
      valueListenable: msgPro.isEmojiPickerOpen,
      builder: (BuildContext context, bool isOpen, Widget? child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: isOpen ? _pickerHeight : 0,
          child: isOpen
              ? ClipRect(
                  child: SizedBox(
                    height: _pickerHeight,
                    child: EmojiPicker(
                      onBackspacePressed: () {},
                      textEditingController: msgPro.message,
                      config: Config(
                        checkPlatformCompatibility: true,
                        emojiViewConfig: EmojiViewConfig(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          emojiSizeMax: 28,
                        ),
                        viewOrderConfig: const ViewOrderConfig(
                          top: EmojiPickerItem.categoryBar,
                          middle: EmojiPickerItem.emojiView,
                          bottom: EmojiPickerItem.searchBar,
                        ),
                        categoryViewConfig: CategoryViewConfig(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                        ),
                        bottomActionBarConfig: BottomActionBarConfig(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                        ),
                        searchViewConfig: SearchViewConfig(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}
