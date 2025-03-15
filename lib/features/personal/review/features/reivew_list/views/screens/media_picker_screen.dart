import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../providers/review_provider.dart';
import '../widgets/media_grid.dart';
import '../widgets/media_preview.dart';

class MediaPickerScreen extends StatefulWidget {
  const MediaPickerScreen({super.key});
  static const String routeName = '/pick-media';

  @override
  State<MediaPickerScreen> createState() => _MediaPickerScreenState();
}

class _MediaPickerScreenState extends State<MediaPickerScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ReviewProvider>(context, listen: false).fetchMedia();
  }

  @override
  Widget build(BuildContext context) {
    final ReviewProvider provider = Provider.of<ReviewProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('photo_videos'.tr()),
        actions: <Widget>[
          if (provider.selectedMedia.isNotEmpty)
            TextButton(
              onPressed: () {
                Navigator.pop(context, provider.selectedMedia);
              },
              child: Text(
                'Done (${provider.selectedMedia.length})',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
        ],
      ),
      body: Column(
        children: <Widget>[
          if (provider.selectedMedia.isNotEmpty) const MediaPreviewWidget(),
          const MediaGridWidget(),
        ],
      ),
    );
  }
}
