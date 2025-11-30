import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';

class DocumentTile extends StatefulWidget {
  const DocumentTile({
    required this.message,
    super.key,
  });

  final MessageEntity message;

  @override
  State<DocumentTile> createState() => _DocumentTileState();
}

class _DocumentTileState extends State<DocumentTile> {
  bool _isDownloading = false;
  double _progress = 0.0;
  String? _localFilePath;
  bool _isDownloaded = false;

  @override
  void initState() {
    super.initState();
    _checkIfFileExists();
  }

  Future<void> _checkIfFileExists() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String filePath =
        '${dir.path}/${widget.message.fileUrl.first.originalName}';
    final File file = File(filePath);

    if (await file.exists()) {
      setState(() {
        _localFilePath = filePath;
        _isDownloaded = true;
      });
    }
  }

  Future<void> _downloadFile() async {
    try {
      setState(() {
        _isDownloading = true;
        _progress = 0.0;
      });
      final Directory dir = await getApplicationDocumentsDirectory();
      final String filePath = '${dir.path}/${widget.message.createdAt}';
      final File file = File(filePath);

      final http.Request request =
          http.Request('GET', Uri.parse(widget.message.fileUrl.first.url));
      final http.StreamedResponse response = await request.send();

      if (response.statusCode != 200) {
        throw Exception('Failed to download file');
      }

      final int contentLength = response.contentLength ?? 0;
      final List<int> bytes = <int>[];
      int received = 0;

      response.stream.listen(
        (List<int> newBytes) {
          bytes.addAll(newBytes);
          received += newBytes.length;
          if (contentLength != 0) {
            setState(() => _progress = received / contentLength);
          }
        },
        onDone: () async {
          await file.writeAsBytes(bytes);
          setState(() {
            _isDownloading = false;
            _isDownloaded = true;
            _localFilePath = file.path;
          });
        },
        onError: (e) {
          setState(() {
            _isDownloading = false;
            _progress = 0.0;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Download failed')),
          );
        },
        cancelOnError: true,
      );
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _progress = 0.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to download file')),
      );
    }
  }

  Future<void> _openFile() async {
    if (_localFilePath != null) {
      await OpenFile.open(_localFilePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: _isDownloaded
          ? _openFile
          : _isDownloading
              ? null
              : _downloadFile,
      child: Row(
        children: <Widget>[
          Icon(Icons.insert_drive_file, color: colorScheme.outline, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.message.fileUrl.first.originalName,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (_isDownloading)
            SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: _progress == 0.0 ? null : _progress,
              ),
            )
          else if (!_isDownloaded)
            Icon(Icons.download_outlined, size: 20, color: colorScheme.outline),
        ],
      ),
    );
  }
}
