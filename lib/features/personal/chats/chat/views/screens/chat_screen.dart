import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../chat_dashboard/data/models/chat/chat_model.dart';
import '../../../chat_dashboard/data/sources/local/local_unseen_messages.dart';
import '../providers/chat_provider.dart';
import '../widgets/app_bar/chat_app_bar.dart';
import '../widgets/chat_interaction_panel/chat_interaction_panel.dart';
import '../widgets/pinned_message.dart/pinned_message.dart';
import '../widgets/message/messages_list.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const String routeName = '/chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Future<void>.delayed(const Duration(milliseconds: 300), () {
      // ignore: use_build_context_synchronously
      Provider.of<ChatProvider>(context, listen: false).getMessages();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (BuildContext context, ChatProvider pro, _) {
        final ChatEntity? chat = pro.chat;

        // Handle null chat state
        if (chat == null) {
          return Scaffold(
            backgroundColor: Theme.of(context).canvasColor,
            appBar: chatAppBar(context),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return PopScope(
          onPopInvokedWithResult: (bool didPop, Object? result) {
            LocalUnreadMessagesService().clearCount(chat.chatId);
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).canvasColor,
            resizeToAvoidBottomInset: true,
            appBar: chatAppBar(context),
            body: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Image.asset(AppStrings.chatBGJpg, fit: BoxFit.cover),
                ),
                Positioned.fill(
                  child: Column(
                    children: <Widget>[
                      ChatPinnedMessage(chatId: chat.chatId),
                      MessagesList(
                        chat: chat,
                        controller: scrollController,
                      ),
                      const ChatInteractionPanel(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
