import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/video_widget.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';

class PostDetailAttachmentSlider extends StatefulWidget {
  PostDetailAttachmentSlider({
    required this.attachments,
    this.showThumbnails = true,
    super.key,
  }) : assert(
          attachments.every(
            (dynamic attachment) =>
                attachment is AttachmentEntity ||
                attachment is PickedAttachment,
          ),
        );

  final List<dynamic> attachments;
  final bool showThumbnails;

  @override
  State<PostDetailAttachmentSlider> createState() =>
      _PostDetailAttachmentSliderState();
}

class _PostDetailAttachmentSliderState
    extends State<PostDetailAttachmentSlider> {
  int selectedIndex = 0;

  // Get URL or local file path
  String _getAttachmentUrl(dynamic attachment) {
    if (attachment is AttachmentEntity) return attachment.url;
    if (attachment is PickedAttachment) return attachment.file.path;
    return '';
  }

  // Check if attachment is a video
  bool _isVideo(dynamic attachment) {
    if (attachment is AttachmentEntity) {
      return attachment.type == AttachmentType.video;
    } else if (attachment is PickedAttachment) {
      return attachment.type == AttachmentType.video;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.attachments.isEmpty) {
      return Center(
        child: Text('no_attachments'.tr()),
      );
    }

    final dynamic currentAttachment = widget.attachments[selectedIndex];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Main image or video display
        AspectRatio(
          aspectRatio: 1,
          child: _isVideo(currentAttachment)
              ? _buildVideoPreview(currentAttachment)
              : _buildImagePreview(currentAttachment),
        ),
        // Thumbnails if enabled
        if (widget.showThumbnails && widget.attachments.length > 1) ...<Widget>[
          const SizedBox(height: 10),
          _buildThumbnailStrip(),
        ],
      ],
    );
  }

  /// Builds the main image preview
  Widget _buildImagePreview(dynamic attachment) {
    final String url = _getAttachmentUrl(attachment);
    final bool isNetwork = url.startsWith('http');

    return InteractiveViewer(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: isNetwork
            ? CustomNetworkImage(imageURL: url)
            : Image.file(File(url), fit: BoxFit.cover),
      ),
    );
  }

  /// Builds a static video thumbnail with play icon
  Widget _buildVideoPreview(dynamic attachment) {
    final dynamic url = _getAttachmentUrl(attachment);

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: ColorScheme.of(context).outline.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8)),
          child: VideoWidget(
            videoSource: url,
            play: true,
          ),
        )
      ],
    );
  }

  /// Builds the horizontal list of thumbnails
  Widget _buildThumbnailStrip() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: widget.attachments.length,
        itemBuilder: (BuildContext context, int index) {
          final dynamic attachment = widget.attachments[index];
          final String url = _getAttachmentUrl(attachment);
          final bool isNetwork = url.startsWith('http');
          final bool isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => setState(() => selectedIndex = index),
            child: Container(
              height: 100,
              width: 100,
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.secondary,
                    width: 2,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                      blurRadius: 2,
                      spreadRadius: 1,
                    ),
                  ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _isVideo(attachment)
                    ? VideoWidget(
                        play: false,
                        showTime: true,
                        durationFontSize: 10,
                        videoSource: url,
                      )
                    : Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          isNetwork
                              ? CustomNetworkImage(imageURL: url)
                              : Image.file(File(url), fit: BoxFit.cover),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
