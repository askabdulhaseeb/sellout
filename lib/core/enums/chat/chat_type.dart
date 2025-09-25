import 'package:hive/hive.dart';
part 'chat_type.g.dart';

@HiveType(typeId: 28)
enum ChatType {
  @HiveField(0)
  private('private', 'private'),
  @HiveField(1)
  product('product', 'product'),
  @HiveField(2)
  group('group', 'group'),
  @HiveField(3)
  service('service', 'service'),
  @HiveField(4)
  requestQuote('request_quote', 'request_quote');

  const ChatType(this.code, this.json);

  final String code;
  final String json;

  static ChatType fromJson(String? json) => values.firstWhere(
        (ChatType e) => e.json == json,
        orElse: () => ChatType.private,
      );
}
