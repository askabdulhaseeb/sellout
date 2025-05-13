import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/video_widget.dart';
import '../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../providers/review_provider.dart';

class ReviewMediaPreviewScreen extends StatefulWidget {
  const ReviewMediaPreviewScreen({super.key});

  @override
  State<ReviewMediaPreviewScreen> createState() =>
      _ReviewMediaPreviewScreenState();
}

class _ReviewMediaPreviewScreenState extends State<ReviewMediaPreviewScreen> {
  @override
  void initState() {
    super.initState();
    // Schedule the media selection after build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ReviewProvider provider =
          Provider.of<ReviewProvider>(context, listen: false);

      provider.setImages(context, type: AttachmentType.media);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('photo_videos'.tr())),
      body: Consumer<ReviewProvider>(
        builder:
            (BuildContext context, ReviewProvider provider, Widget? child) {
          return provider.attachments.isEmpty
              ? Center(child: Text('no_media_selected'.tr()))
              : const Column(
                  children: <Widget>[
                    Expanded(child: MediaPreview()),
                    MediaListView(),
                  ],
                );
        },
      ),
    );
  }
}

class MediaPreview extends StatelessWidget {
  const MediaPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewProvider>(
      builder: (BuildContext context, ReviewProvider provider, Widget? child) {
        final List<PickedAttachment> attachments = provider.attachments;
        if (attachments.isEmpty) {
          return const SizedBox.shrink();
        }

        final PickedAttachment media = attachments[provider.currentIndex];

        return Container(
          margin: const EdgeInsets.all(16),
          child: media.type == AttachmentType.video
              ? Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    VideoWidget(
                      videoSource: media.file.path,
                      play: true,
                    ),
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    media.file,
                    fit: BoxFit.cover,
                  ),
                ),
        );
      },
    );
  }
}

class MediaListView extends StatelessWidget {
  const MediaListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewProvider>(
      builder: (BuildContext context, ReviewProvider provider, Widget? child) {
        final List<PickedAttachment> attachments = provider.attachments;
        if (attachments.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: attachments.length,
            itemBuilder: (BuildContext context, int index) {
              final PickedAttachment media = attachments[index];
              final bool isSelected = index == provider.currentIndex;

              return GestureDetector(
                onTap: () => provider.setCurrentIndex(index),
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        border: Border.all(
                          color: isSelected
                              ? ColorScheme.of(context).secondary
                              : ColorScheme.of(context).primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: media.type == AttachmentType.video
                            ? Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  AbsorbPointer(
                                    child: VideoWidget(
                                      showTime: true,
                                      videoSource: media.file.path,
                                      play: false,
                                    ),
                                  ),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  media.file,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => provider.removeAttachment(index),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8)),
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
