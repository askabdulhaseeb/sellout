import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../attachment/domain/entities/attachment_entity.dart';

class DocumentTile extends StatefulWidget {
  const DocumentTile({required this.attachment, required this.isMe, super.key});
  final AttachmentEntity attachment;
  final bool isMe;
  @override
  State<DocumentTile> createState() => _DocumentTileState();
}

class _DocumentTileState extends State<DocumentTile> {
  bool isDownloading = false;
  bool fileExists = false;
  late String filePath;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _downloadFile() async {
    final String url = widget.attachment.url;
    final String fileName = widget.attachment.originalName;

    setState(() => isDownloading = true);

    try {
      if (Platform.isAndroid) {
        final PermissionStatus status = await Permission.storage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tr('document_tile.storageDenied'))),
          );
          setState(() => isDownloading = false);
          return;
        }
      }

      final http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Directory? directory = await getExternalStorageDirectory();
        if (directory == null) throw Exception('Storage directory not found');
        filePath = '${directory.path}/$fileName';
        final File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        final bool exists = await file.exists();
        if (exists) {
          setState(() {
            fileExists = true;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('document_tile.downloadedTo'.tr())),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('document_tile.downloadFailed'.tr())),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('document_tile.downloadHttpFailed'.tr())),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('document_tile.error'.tr())),
      );
    } finally {
      setState(() => isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isMe = widget.isMe; // you must have this field

    final Color tileColor = isMe
        ? colorScheme.secondary.withValues(alpha: 0.2)
        : colorScheme.primary.withValues(alpha: 0.2);
    final Color iconColor = isMe
        ? colorScheme.onSecondary.withValues(alpha: 0.8)
        : colorScheme.onPrimary.withValues(alpha: 0.8);
    final Color textColor =
        isMe ? colorScheme.onSecondary : colorScheme.onPrimary;
    final Color buttonBgColor = isMe
        ? colorScheme.secondary.withValues(alpha: 0.2)
        : colorScheme.primary.withValues(alpha: 0.2);
    final Color buttonTextColor =
        isMe ? colorScheme.secondary : colorScheme.primary;
    // final Color dividerColor = theme.dividerColor;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: tileColor,
            ),
            child: Center(
              child: Icon(
                Icons.insert_drive_file_rounded,
                size: 36,
                color: iconColor,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.attachment.originalName,
            style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: CustomElevatedButton(
              bgColor: buttonBgColor,
              textStyle: TextTheme.of(context)
                  .labelMedium
                  ?.copyWith(color: buttonTextColor),
              isLoading: isDownloading,
              title: isDownloading ? 'downloading'.tr() : 'download'.tr(),
              onTap: _downloadFile,
            ),
          ),
        ],
      ),
    );
  }
}
