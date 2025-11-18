import 'dart:convert';
import '../../../../../../core/enums/core/status_type.dart';

class UpdateQuoteParams {
  UpdateQuoteParams({
    required this.quoteId,
    required this.messageId,
    required this.chatId,
    required this.status,
  });
  final String quoteId;
  final String messageId;
  final String chatId;
  final StatusType status;

  /// To Map (Object → JSON)
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'quote_id': quoteId,
      'message_id': messageId,
      'chat_id': chatId,
      'status': status.json,
    };
  }

  /// Optional: to JSON string
  String toJson() => jsonEncode(toMap());
}
