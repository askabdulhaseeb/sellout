import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../../../core/widgets/custom_memory_image.dart';
import '../../../../../../../attachment/domain/entities/attachment_entity.dart';

class ContactMessageTile extends StatefulWidget {
  const ContactMessageTile({
    required this.attachment,
    required this.isMe,
    super.key,
  });

  final AttachmentEntity attachment;
  final bool isMe;

  @override
  State<ContactMessageTile> createState() => _ContactMessageTileState();
}

class _ContactMessageTileState extends State<ContactMessageTile> {
  bool _isDownloading = false;
  bool _isDownloaded = false;
  Map<String, String>? _contactDetails;

  Future<void> _downloadAndParseContact() async {
    try {
      setState(() => _isDownloading = true);

      final Directory dir = await getApplicationDocumentsDirectory();
      final String filePath = '${dir.path}/${widget.attachment.originalName}';
      final File file = File(filePath);

      // Download only if not already saved
      if (!file.existsSync()) {
        final http.Response response =
            await http.get(Uri.parse(widget.attachment.url));
        if (response.statusCode == 200) {
          await file.writeAsBytes(response.bodyBytes);
        } else {
          throw Exception('Failed to download VCF');
        }
      }

      // Parse contact details
      final String content = await file.readAsString();
      _contactDetails = _parseVcf(content);

      setState(() {
        _isDownloaded = true;
      });
    } catch (e) {
      debugPrint('Error downloading contact: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to download contact')),
      );
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  Map<String, String> _parseVcf(String content) {
    final List<String> lines = content.split('\n');
    String? name;
    String? phone;
    String? email;
    String? photo;

    for (final String line in lines) {
      if (line.startsWith('FN:')) {
        name = line.replaceFirst('FN:', '').trim();
      } else if (line.startsWith('TEL')) {
        phone = line.split(':').last.trim();
      } else if (line.startsWith('EMAIL')) {
        email = line.split(':').last.trim();
      } else if (line.startsWith('PHOTO')) {
        photo = line.split(':').last.trim();
      }
    }

    return <String, String>{
      'name': name ?? 'Unknown',
      'phone': phone ?? 'N/A',
      'email': email ?? 'N/A',
      'photo': photo ?? '',
    };
  }

  Future<void> _openDialer(String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openSms(String phone) async {
    final Uri uri = Uri(scheme: 'sms', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openContacts() async {
    // This just opens the phone's contacts app if available
    final Uri uri = Uri(scheme: 'content', path: 'contacts/people');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open contacts app')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final String displayName = _contactDetails?['name'] ??
        widget.attachment.originalName.replaceAll('.vcf', '');
    final String displayPhone = _contactDetails?['phone'] ?? '••• ••• ••••';
    final Uint8List? displayPhoto =
        (_contactDetails != null && _contactDetails!['photo']!.isNotEmpty)
            ? const Base64Decoder().convert(_contactDetails!['photo']!)
            : null;

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomMemoryImage(
            showLoader: true,
            size: 70,
            displayName: displayName,
            photo: displayPhoto,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  displayName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text('${'contact'.tr()}: $displayPhone'),
                if (_isDownloaded)
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.contacts, size: 20),
                        onPressed: _openContacts,
                      ),
                      IconButton(
                        icon: const Icon(Icons.phone, size: 20),
                        onPressed: () => _openDialer(displayPhone),
                      ),
                      IconButton(
                        icon: const Icon(Icons.sms, size: 20),
                        onPressed: () => _openSms(displayPhone),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (_isDownloading)
            const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else if (!_isDownloaded)
            IconButton(
              icon: Icon(Icons.download, size: 20, color: colorScheme.outline),
              onPressed: _downloadAndParseContact,
            ),
        ],
      ),
    );
  }
}
