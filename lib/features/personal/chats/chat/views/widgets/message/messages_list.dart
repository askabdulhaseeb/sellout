import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../core/widgets/empty_page_widget.dart';
import '../../../../chat_dashboard/data/models/chat/chat_model.dart';
import '../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../domain/entities/getted_message_entity.dart';
import '../../helpers/date_label_helper.dart';
import '../../providers/chat_provider.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({required this.chat, required this.controller, super.key});
  final ChatEntity? chat;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final ChatProvider chatProvider = context.watch<ChatProvider>();
    final String? chatId = chatProvider.chat?.chatId;

    if (chatId == null) {
      return Center(
          child: EmptyPageWidget(
        icon: CupertinoIcons.chat_bubble_2,
        childBelow: const Text('no_messages_yet').tr(),
      ));
    }
    final Box<GettedMessageEntity> box =
        Hive.box<GettedMessageEntity>(AppStrings.localChatMessagesBox);
    return ValueListenableBuilder<Box<GettedMessageEntity>>(
      valueListenable: box.listenable(keys: <dynamic>[chatId]),
      builder: (BuildContext context, Box<GettedMessageEntity> box, _) {
        final GettedMessageEntity? stored = box.get(chatId);
        final List<MessageEntity> messages = stored == null
            ? <MessageEntity>[]
            : chatProvider.getFilteredMessages(stored);

        if (messages.isEmpty) {
          return Center(
              child: EmptyPageWidget(
            icon: CupertinoIcons.chat_bubble_2,
            childBelow: const Text('no_messages_yet').tr(),
          ));
        }
        // Calculate time gaps only once
        final Map<String, Duration> timeDiffMap = <String, Duration>{};
        for (int i = 0; i < messages.length; i++) {
          final MessageEntity current = messages[i];
          final MessageEntity? next =
              i < messages.length - 1 ? messages[i + 1] : null;
          final Duration diff = (next != null && current.sendBy == next.sendBy)
              ? next.createdAt.difference(current.createdAt).abs()
              : const Duration(days: 5);
          timeDiffMap[current.messageId] = diff;
        }
        // Build widgets (reversed chat order)
        final List<Widget> widgets =
            DateLabelHelper.buildLabeledWidgets(messages, timeDiffMap);
        return Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            controller: controller,
            itemBuilder: (BuildContext context, int index) {
              return widgets[index];
            },
            itemCount: widgets.length,
          ),
        );
      },
    );
  }
}
