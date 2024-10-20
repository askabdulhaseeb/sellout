import 'package:hive/hive.dart';

part 'message_last_evaluated_key_entity.g.dart';

@HiveType(typeId: 34)
class MessageLastEvaluatedKeyEntity {
  MessageLastEvaluatedKeyEntity({
    required this.chatID,
    required this.paginationKey,
    required this.createdAt,
  });

  @HiveField(0)
  final String chatID;
  @HiveField(1)
  final String? paginationKey;
  @HiveField(2)
  final DateTime createdAt;
}
