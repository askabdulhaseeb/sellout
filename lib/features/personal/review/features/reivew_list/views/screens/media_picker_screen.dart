import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
    final ReviewProvider pro =
        Provider.of<ReviewProvider>(context, listen: false);
    pro.fetchMedia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('photo_videos'.tr())),
      body: const Column(
        children: <Widget>[
          MediaPreview(),
          MediaGridView(),
        ],
      ),
    );
  }
}
