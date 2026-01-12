import 'package:hive_ce/hive.dart';

part 'message_status.g.dart';

/// Represents the delivery status of a message.
@HiveType(typeId: 96)
enum MessageStatus {
  /// Message is being sent
  @HiveField(0)
  pending('pending'),

  /// Message has been sent to server
  @HiveField(1)
  sent('sent'),

  /// Message has been delivered to recipient
  @HiveField(2)
  delivered('delivered'),

  /// Message has been read by recipient
  @HiveField(3)
  read('read'),

  /// Message failed to send
  @HiveField(4)
  failed('failed');

  const MessageStatus(this.code);
  final String code;

  /// Creates a MessageStatus from a JSON string value
  static MessageStatus fromJson(String? json) {
    if (json == null || json.isEmpty) return MessageStatus.sent;
    return MessageStatus.values.firstWhere(
      (MessageStatus status) => status.code == json.toLowerCase(),
      orElse: () => MessageStatus.sent,
    );
  }

  String get json => code;
}
