import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../attachment/domain/entities/attachment_entity.dart';

class ContactMessageTile extends StatefulWidget {
  const ContactMessageTile({required this.attachment, required this.isMe, super.key});
  final AttachmentEntity attachment;
  final bool isMe;
  @override
  State<ContactMessageTile> createState() => _ContactMessageTileState();
}

class _ContactMessageTileState extends State<ContactMessageTile> {
  bool _showDetails = false;
  Future<Map<String, String>>? _detailsFuture;

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
      'name': name ?? 'Unknown'.tr(),
      'phone': phone ?? 'na'.tr(),
      'email': email ?? 'na'.tr(),
    };
  }

  void _toggleDetails() {
    setState(() {
      _showDetails = !_showDetails;
      if (_showDetails && _detailsFuture == null) {
        _detailsFuture = _parseVcfFromUrl(widget.attachment.url);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String contactName =
        widget.attachment.originalName.replaceAll('.vcf', '');

    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: widget.isMe
                    ? AppTheme.secondaryColor.withValues(alpha: 0.3)
                    : AppTheme.primaryColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10)),
            child: Text('${'contact'.tr()}: $contactName ',
                maxLines: 3, style: TextTheme.of(context).bodySmall),
          ),
          const Divider(),
          if (_showDetails)
            FutureBuilder<Map<String, String>>(
              future: _detailsFuture,
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, String>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('Failed to load contact details'),
                  );
                }

                final Map<String, String> data = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '📞 ${'phone'.tr()}: ${data['phone']}',
                      style: TextTheme.of(context)
                          .bodySmall
                          ?.copyWith(color: ColorScheme.of(context).surface),
                    ),
                    Text(
                      '✉️ ${'email'.tr()}: ${data['email']}',
                      style: TextTheme.of(context)
                          .bodySmall
                          ?.copyWith(color: ColorScheme.of(context).surface),
                    ),
                  ],
                );
              },
            ),
          TextButton(
            onPressed: _toggleDetails,
            child: Text(
              _showDetails ? 'see_all'.tr() : 'see_less'.tr(),
              style: TextTheme.of(context).bodySmall?.copyWith(
                  color: widget.isMe
                      ? AppTheme.secondaryColor
                      : AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
