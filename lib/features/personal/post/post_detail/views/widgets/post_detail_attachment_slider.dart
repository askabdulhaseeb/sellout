import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/widgets/custom_network_image.dart';
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
      return Container(
        height: 250,
        alignment: Alignment.center,
        child: Text('no_attachments'.tr()),
      );
    }

    final currentAttachment = widget.attachments[selectedIndex];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Main image or video display
        SizedBox(
            height: 250,
            width: double.infinity,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isVideo(currentAttachment)
                  ? _buildVideoPreview(currentAttachment)
                  : _buildImagePreview(currentAttachment),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              layoutBuilder:
                  (Widget? currentChild, List<Widget> previousChildren) {
                return currentChild!;
              },
            )),

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
    final String url = _getAttachmentUrl(attachment);
    final bool isNetwork = url.startsWith('http');

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        isNetwork
            ? CustomNetworkImage(imageURL: url)
            : Image.file(File(url), fit: BoxFit.cover),

        // Play icon
        Center(
          child: Icon(
            Icons.play_circle_fill,
            size: 60,
            color: Colors.white.withOpacity(0.8),
          ),
        ),

        // "Video" label
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'video'.tr(),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the horizontal list of thumbnails
  Widget _buildThumbnailStrip() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
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
            child: AnimatedScale(
              scale: selectedIndex == index ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 80,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _isVideo(attachment)
                      ? Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            isNetwork
                                ? CustomNetworkImage(imageURL: url)
                                : Image.file(File(url), fit: BoxFit.cover),
                            const Center(
                              child: Icon(
                                Icons.play_circle_outline,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : isNetwork
                          ? CustomNetworkImage(imageURL: url)
                          : Image.file(File(url), fit: BoxFit.cover),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
