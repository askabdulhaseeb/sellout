import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({
    required this.title,
    required this.assetPath,
    super.key,
  });
  final String title;
  final String assetPath;

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? localPath;
  bool error = false;

  @override
  void initState() {
    super.initState();
    _preparePdf();
  }

  Future<void> _preparePdf() async {
    try {
      final ByteData bytes = await rootBundle.load(widget.assetPath);
      final Uint8List list = bytes.buffer.asUint8List();
      final Directory tempDir = await getTemporaryDirectory();
      final File file = File(
        '${tempDir.path}/${widget.assetPath.split('/').last}',
      );
      await file.writeAsBytes(list, flush: true);
      setState(() {
        localPath = file.path;
      });
    } catch (e) {
      setState(() {
        error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AppBarTitle(titleKey: widget.title)),
      body: error
          ? const Center(child: Text('Failed to load PDF'))
          : localPath == null
          ? const Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: localPath!,
              fitEachPage: true,
              fitPolicy: FitPolicy.WIDTH,
            ),
    );
  }
}
