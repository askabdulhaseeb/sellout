import 'dart:convert';

class UpdateQuoteParams {
  UpdateQuoteParams({
    required this.quoteId,
    required this.messageId,
    required this.chatId,
    required this.status,
  });

  /// From Map (JSON → Object)
  factory UpdateQuoteParams.fromMap(Map<String, dynamic> map) {
    return UpdateQuoteParams(
      quoteId: map['quote_id'] ?? '',
      messageId: map['message_id'] ?? '',
      chatId: map['chat_id'] ?? '',
      status: map['status'] ?? '',
    );
  }

  /// Optional: from JSON string
  factory UpdateQuoteParams.fromJson(String source) =>
      UpdateQuoteParams.fromMap(jsonDecode(source));
  final String quoteId;
  final String messageId;
  final String chatId;
  final String status;

  /// To Map (Object → JSON)
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'quote_id': quoteId,
      'message_id': messageId,
      'chat_id': chatId,
      'status': status,
    };
  }

  /// Optional: to JSON string
  String toJson() => jsonEncode(toMap());
}
