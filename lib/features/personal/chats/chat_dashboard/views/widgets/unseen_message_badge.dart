import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../domain/entities/chat/unread_message_entity.dart';

class UnreadMessageBadgeWidget extends StatelessWidget {

  const UnreadMessageBadgeWidget({required this.chatId, super.key});
  final String chatId;

  @override
  Widget build(BuildContext context) {
    final Box<UnreadMessageEntity> unreadCountBox = Hive.box<UnreadMessageEntity>(AppStrings.localUnreadMessages);

    return ValueListenableBuilder(
      valueListenable: unreadCountBox.listenable(keys: <dynamic>[chatId]),
      builder: (BuildContext context, Box<UnreadMessageEntity> box, _) {
        final int count = box.get(chatId)?.count ?? 0;
        if (count == 0) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
          constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
          alignment: Alignment.center,
          child: Text(
            count.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
