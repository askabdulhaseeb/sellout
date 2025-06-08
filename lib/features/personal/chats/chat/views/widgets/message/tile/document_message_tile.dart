import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../attachment/domain/entities/attachment_entity.dart';

class DocumentTile extends StatefulWidget {
  const DocumentTile({required this.attachment, super.key});
  final AttachmentEntity attachment;

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
        if (directory == null) throw Exception("Storage directory not found");

        filePath = '${directory.path}/$fileName';
        final File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        final bool exists = await file.exists();
        if (exists) {
          setState(() {
            fileExists = true;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tr('document_tile.downloadedTo', args: [filePath]))),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tr('document_tile.downloadFailed'))),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr('document_tile.downloadHttpFailed'))),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr('document_tile.error', args: [e.toString()]))),
      );
    } finally {
      setState(() => isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.insert_drive_file_rounded,
            size: 36,
            color: colorScheme.secondary.withOpacity(0.8),
          ),
          const SizedBox(height: 12),
          Text(
            widget.attachment.originalName,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 100,
            child: CustomElevatedButton(
              isLoading: isDownloading,
              title: isDownloading
                  ? tr('document_tile.downloading')
                  : tr('document_tile.download'),
              onTap: _downloadFile,
            )
          ),
        ],
      ),
    );
  }
}
