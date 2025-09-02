import 'dart:io';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../../../core/widgets/custom_elevated_button.dart';
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
  Contact? _contact;

  @override
  void initState() {
    super.initState();
    _downloadAndParseContact();
  }

  Future<void> _downloadAndParseContact() async {
    try {
      final Directory dir = await getApplicationDocumentsDirectory();
      final String filePath = '${dir.path}/${widget.attachment.originalName}';
      final File file = File(filePath);

      // Download only if not cached
      if (!file.existsSync()) {
        final http.Response response =
            await http.get(Uri.parse(widget.attachment.url));
        if (response.statusCode == 200) {
          await file.writeAsBytes(response.bodyBytes);
        } else {
          throw Exception('Failed to download VCF');
        }
      }

      final String content = await file.readAsString();
      final Contact parsedContact = Contact.fromVCard(content);
      setState(() {
        _contact = parsedContact;
      });
    } catch (e) {
      debugPrint('Error downloading/parsing contact: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load contact')),
      );
    }
  }

  Future<void> _openSms(String phone) async {
    final Uri uri = Uri(scheme: 'sms', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final String displayName = _contact?.displayName ??
        widget.attachment.originalName.replaceAll('.vcf', '');
    final String displayPhone = (_contact?.phones.isNotEmpty ?? false)
        ? _contact!.phones.first.number
        : '••• ••• ••••';
    final String displayOrg = (_contact?.organizations.isNotEmpty ?? false)
        ? _contact!.organizations.first.title
        : '';

    final Uint8List? displayPhoto = _contact?.photo;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomMemoryImage(
                showLoader: true,
                size: 50,
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (displayOrg.isNotEmpty)
                      Text(
                        displayOrg,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.outline,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: 100,
              child: CustomElevatedButton(
                onTap: () => _openSms(displayPhone),
                isLoading: false,
                title: 'message'.tr(),
                textStyle: theme.textTheme.bodySmall,
                bgColor: theme.scaffoldBackgroundColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
