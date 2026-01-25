import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/sockets/socket_service.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../../../../services/get_it.dart';
import '../../../chat_dashboard/data/models/chat/chat_model.dart';
import '../../../chat_dashboard/data/sources/local/local_unseen_messages.dart';
import '../providers/chat_provider.dart';
import '../widgets/app_bar/chat_app_bar.dart';
import '../widgets/chat_interaction_panel/chat_interaction_panel.dart';
import '../widgets/pinned_message/pinned_message.dart';
import '../widgets/message/messages_list.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const String routeName = '/chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController scrollController = ScrollController();
  String? _currentChatId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final ChatProvider provider = context.read<ChatProvider>();
      provider.getMessages();

      // Emit joinChat when screen opens
      final String? chatId = provider.chat?.chatId;
      if (chatId != null) {
        _currentChatId = chatId;
        locator<SocketService>().joinChat(chatId);
      }
    });
  }

  @override
  void dispose() {
    // Emit leaveChat when screen closes
    if (_currentChatId != null) {
      locator<SocketService>().leaveChat(_currentChatId!);
    }
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
            body: const Center(child: CircularProgressIndicator()),
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
                      Expanded(
                        child: MessagesList(
                          chat: chat,
                          controller: scrollController,
                        ),
                      ),
                      if (!pro.isOtherUserBlocked) const ChatInteractionPanel(),
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
