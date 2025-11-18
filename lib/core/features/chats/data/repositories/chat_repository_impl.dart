import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final http.Client client;
  final String baseUrl;

  ChatRepositoryImpl({http.Client? client, required this.baseUrl})
      : client = client ?? http.Client();

  @override
  Future<void> createPostInquiryChat(
      {required String postId, required String text}) async {
    final url = Uri.parse('$baseUrl/chat/post/inquiry');
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'post_id': postId,
        'text': text,
      }),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to create post inquiry chat');
    }
  }
}
