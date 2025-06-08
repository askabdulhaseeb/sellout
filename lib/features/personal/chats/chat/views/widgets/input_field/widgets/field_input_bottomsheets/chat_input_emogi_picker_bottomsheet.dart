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
          height: 400,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(8),
          child: EmojiPicker(
            onEmojiSelected:(Category? category, Emoji emoji) =>  {
              chatPro.message.text += emoji.emoji,
              chatPro.message.selection = TextSelection.fromPosition(
                TextPosition(offset: chatPro.message.text.length),
              ),
            },
            config: Config(bottomActionBarConfig: BottomActionBarConfig(backgroundColor: Theme.of(context).scaffoldBackgroundColor,),categoryViewConfig: CategoryViewConfig(
              // bgColor: 
              indicatorColor: Theme.of(context).primaryColor,
              iconColor: Theme.of(context).disabledColor,
              iconColorSelected: Theme.of(context).primaryColor,
              // recentsLimit: 30,
              tabIndicatorAnimDuration: kTabScrollDuration,
              categoryIcons: const CategoryIcons(),
              // buttonMode: ButtonMode.CUPERTINO,
             // enableSkinTones: true,
              ),
              
            ),
          ),
        ),
      );
    },
  );
}
