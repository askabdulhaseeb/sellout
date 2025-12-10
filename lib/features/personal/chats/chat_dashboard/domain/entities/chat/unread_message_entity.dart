import 'package:hive_ce/hive.dart';
part 'unread_message_entity.g.dart';

@HiveType(typeId: 55)
class UnreadMessageEntity extends HiveObject {
  UnreadMessageEntity({required this.chatId, required this.count});
  @HiveField(0)
  String chatId;

  @HiveField(1)
  int count;
}
