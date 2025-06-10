import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/chat_provider.dart';

void showEmojiPickerBottomSheet(BuildContext context) {
  showModalBottomSheet(
    isDismissible: true,
    enableDrag: false,
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext subcontext) {
      final ChatProvider chatPro = Provider.of<ChatProvider>(context, listen: false); // <-- replace with your class
      return Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        child: Container(
          height: 450,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: EmojiPicker(
    onBackspacePressed: () {
    },
    textEditingController: chatPro.message, 
    config: Config(
        height: 260,
        checkPlatformCompatibility: true,
        emojiViewConfig:  EmojiViewConfig(
        emojiSizeMax: 20,
        backgroundColor: Theme.of(context).cardColor
        ),
        viewOrderConfig: const ViewOrderConfig(
            top: EmojiPickerItem.categoryBar,
            middle: EmojiPickerItem.emojiView,
            bottom: EmojiPickerItem.searchBar,
        ),
        skinToneConfig: const SkinToneConfig(),
        categoryViewConfig:  CategoryViewConfig(backgroundColor: Theme.of(context).scaffoldBackgroundColor),
        bottomActionBarConfig:  BottomActionBarConfig(backgroundColor: Theme.of(context).scaffoldBackgroundColor),
        searchViewConfig:  SearchViewConfig(backgroundColor: Theme.of(context).scaffoldBackgroundColor),
    ),
)   ),
      );
    },
  );
}
