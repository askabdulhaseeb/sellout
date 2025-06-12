import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../../../attachment/domain/entities/attachment_entity.dart';

class ContactMessageTile extends StatelessWidget {
  const ContactMessageTile({super.key, required this.attachment});
  final AttachmentEntity attachment;

  Future<Map<String, String>> _parseVcfFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) throw Exception('Failed to load VCF');

    final String content = response.body;
    final List<String> lines = content.split('\n');

    String? name;
    String? phone;
    String? email;

    for (final String line in lines) {
      if (line.startsWith('FN:')) {
        name = line.replaceFirst('FN:', '').trim();
      } else if (line.startsWith('TEL')) {
        phone = line.split(':').last.trim();
      } else if (line.startsWith('EMAIL')) {
        email = line.split(':').last.trim();
      }
    }

    return <String, String>{
      'name': name ?? 'Unknown',
      'phone': phone ?? 'N/A',
      'email': email ?? 'N/A',
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _parseVcfFromUrl(attachment.url),
      builder: (BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Failed to load contact'),
          );
        }

        final Map<String, String> data = snapshot.data!;
        return Card(
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(data['name']!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('📞 Phone: ${data['phone']}'),
                Text('✉️ Email: ${data['email']}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
