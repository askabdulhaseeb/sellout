import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../../../../core/theme/app_theme.dart';
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
  Future<Map<String, String>>? _detailsFuture;

  @override
  void initState() {
    super.initState();
    _detailsFuture = _parseVcfFromUrl(widget.attachment.url);
  }

  Future<Map<String, String>> _parseVcfFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) throw Exception('Failed to load VCF');

    final String content = response.body;
    final List<String> lines = content.split('\n');

    String? name;
    String? phone;
    String? email;
    String? photo; // Optional photo (if stored as base64 in VCF)

    for (final String line in lines) {
      if (line.startsWith('FN:')) {
        name = line.replaceFirst('FN:', '').trim();
      } else if (line.startsWith('TEL')) {
        phone = line.split(':').last.trim();
      } else if (line.startsWith('EMAIL')) {
        email = line.split(':').last.trim();
      } else if (line.startsWith('PHOTO')) {
        photo = line.split(':').last.trim(); // Can decode base64 if needed
      }
    }

    return <String, String>{
      'name': name ?? 'Unknown',
      'phone': phone ?? 'N/A',
      'email': email ?? 'N/A',
      'photo': photo ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _detailsFuture,
      builder: (context, snapshot) {
        final ThemeData theme = Theme.of(context);
        final ColorScheme colorScheme = theme.colorScheme;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.isMe
                  ? AppTheme.secondaryColor.withOpacity(0.2)
                  : AppTheme.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('Failed to load contact details'),
          );
        }

        final Map<String, String> data = snapshot.data!;
        final String contactName = data['name'] ??
            widget.attachment.originalName.replaceAll('.vcf', '');

        return Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            // color: widget.isMe
            //     ? AppTheme.secondaryColor.withOpacity(0.2)
            //     : AppTheme.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            spacing: 6,
            children: <Widget>[
              CustomMemoryImage(
                  size: 70,
                  displayName: contactName,
                  photo: const Base64Decoder().convert(data['photo']!)),
              // Contact details
              Expanded(
                child: Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contactName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(data['phone'] ?? 'na'.tr()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
