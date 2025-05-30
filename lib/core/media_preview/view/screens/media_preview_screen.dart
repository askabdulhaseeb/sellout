import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../features/attachment/domain/entities/picked_attachment.dart';
import '../../../theme/app_theme.dart';
import '../provider/media_preview_provider.dart';
import '../widgets/llistview_widget.dart';
import '../widgets/preview_widget.dart';

class ReviewMediaPreviewScreen extends StatelessWidget {
  const ReviewMediaPreviewScreen({required this.attachments, super.key});
  final List<PickedAttachment> attachments;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MediaPreviewProvider>(
      create: (_) => MediaPreviewProvider(attachments),
      child: const ReviewMediaPreviewContent(),
    );
  }
}

class ReviewMediaPreviewContent extends StatefulWidget {
  const ReviewMediaPreviewContent({super.key});

  @override
  State<ReviewMediaPreviewContent> createState() =>
      _ReviewMediaPreviewContentState();
}

class _ReviewMediaPreviewContentState extends State<ReviewMediaPreviewContent> {
  late MediaPreviewProvider provider;

  @override
  void initState() {
    super.initState();
    // Initialize provider reference after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = Provider.of<MediaPreviewProvider>(context, listen: false);
      if (provider.attachments.isEmpty) {
        _showMediaOptions();
      }
    });
  }

  Future<void> _showMediaOptions() async {
    final AttachmentType? choice = await showModalBottomSheet<AttachmentType>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo),
              title: Text('add_photo'.tr()),
              onTap: () => Navigator.pop(context, AttachmentType.image),
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: Text('add_video'.tr()),
              onTap: () => Navigator.pop(context, AttachmentType.video),
            ),
          ],
        );
      },
    );

    if (choice != null) {
      await provider.setImages(context, type: choice);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('photo_videos'.tr())),
      body: Consumer<MediaPreviewProvider>(
        builder: (BuildContext context, MediaPreviewProvider provider,
            Widget? child) {
          if (provider.attachments.isEmpty) {
            return Center(child: Text('no_media_selected'.tr()));
          }
          return const Column(
            children: <Widget>[
              Expanded(child: MediaPreview()),
              MediaListView(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        onPressed: _showMediaOptions,
        tooltip: 'add_media'.tr(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
