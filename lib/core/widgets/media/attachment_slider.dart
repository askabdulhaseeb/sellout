import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../features/attachment/domain/entities/attachment_entity.dart'
    as remote;
import '../../../features/attachment/domain/entities/picked_attachment.dart'
    as picked;
import '../../enums/core/attachment_type.dart';
import 'custom_network_image.dart';
import 'video_widget.dart';

class AttachmentsSlider extends StatefulWidget {
  // Backwards-compatible constructor for remote attachments only
  const AttachmentsSlider({
    required List<remote.AttachmentEntity> attachments,
    super.key,
    this.aspectRatio = 4 / 3,
    this.width,
    this.height,
  }) : remoteAttachments = attachments,
       pickedAttachments = const <picked.PickedAttachment>[];

  // New: picked-only
  const AttachmentsSlider.picked({
    required List<picked.PickedAttachment> attachments,
    super.key,
    this.aspectRatio = 4 / 3,
    this.width,
    this.height,
  }) : remoteAttachments = const <remote.AttachmentEntity>[],
       pickedAttachments = attachments;

  // New: mixed
  const AttachmentsSlider.mixed({
    List<remote.AttachmentEntity> remote = const <remote.AttachmentEntity>[],
    List<picked.PickedAttachment> picked = const <picked.PickedAttachment>[],
    super.key,
    this.aspectRatio = 4 / 3,
    this.width,
    this.height,
  }) : remoteAttachments = remote,
       pickedAttachments = picked;

  final List<remote.AttachmentEntity> remoteAttachments;
  final List<picked.PickedAttachment> pickedAttachments;
  final double aspectRatio;
  final double? width;
  final double? height;

  @override
  State<AttachmentsSlider> createState() => _AttachmentsSliderState();
}

class _AttachmentsSliderState extends State<AttachmentsSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Merge remote and picked into a single display list
    final List<_RenderableAttachment> items = <_RenderableAttachment>[
      ...widget.remoteAttachments.map((remote.AttachmentEntity e) {
        final bool isVideo = e.type == AttachmentType.video;
        return _RenderableAttachment(isVideo: isVideo, url: e.url);
      }),
      ...widget.pickedAttachments.map((picked.PickedAttachment p) {
        bool isVideo;
        // Prefer the AssetEntity type when available
        if (p.selectedMedia != null) {
          isVideo = p.selectedMedia!.type == AssetType.video;
        } else {
          // Fallback 1: file extension check
          final String path = p.file.path.toLowerCase();
          final bool extVideo =
              path.endsWith('.mp4') ||
              path.endsWith('.mov') ||
              path.endsWith('.m4v') ||
              path.endsWith('.mkv') ||
              path.endsWith('.webm') ||
              path.endsWith('.avi') ||
              path.endsWith('.3gp');
          // Fallback 2: declared attachment type
          isVideo = extVideo || p.type == AttachmentType.video;
        }

        return _RenderableAttachment(
          isVideo: isVideo,
          file: p.file,
          asset: p.selectedMedia,
        );
      }),
    ];

    if (items.isEmpty) {
      return const SizedBox();
    }
    final int totalLength = items.length;
    return SizedBox(
      height: widget.height ?? 300,
      width: widget.width ?? MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          PageView.builder(
            itemCount: totalLength,
            onPageChanged: (int index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (BuildContext context, int index) {
              final _RenderableAttachment item = items[index];
              return SizedBox.expand(
                child: item.isVideo
                    ? VideoWidget(
                        videoSource: item.url ?? item.file!.path,
                        play: true,
                      )
                    : InteractiveViewer(child: _buildImageFor(item)),
              );
            },
          ),
          if (totalLength > 1)
            Positioned(
              top: 8,
              right: 8,
              child: _SliderCounter(index: _currentIndex, total: totalLength),
            ),
        ],
      ),
    );
  }
}

class _RenderableAttachment {
  const _RenderableAttachment({
    required this.isVideo,
    this.url,
    this.file,
    this.asset,
  });

  final bool isVideo;
  final String? url; // remote
  final File? file; // local
  final AssetEntity? asset; // original asset for safe thumbnails
}

Widget _buildImageFor(_RenderableAttachment item) {
  // Remote case
  if (item.file == null && item.url != null) {
    return CustomNetworkImage(imageURL: item.url!, fit: BoxFit.cover);
  }

  // Local file case
  final String path = item.file?.path ?? '';
  final String lower = path.toLowerCase();
  final bool looksHeic = lower.endsWith('.heic') || lower.endsWith('.heif');

  // For HEIC/HEIF prefer a large JPEG thumbnail to avoid engine decoder issues
  if (looksHeic && item.asset != null) {
    return FutureBuilder<Uint8List?>(
      future: item.asset!.thumbnailDataWithSize(
        const ThumbnailSize(1200, 1200),
        quality: 90,
        format: ThumbnailFormat.jpeg,
      ),
      builder: (BuildContext context, AsyncSnapshot<Uint8List?> snap) {
        final Uint8List? bytes = snap.data;
        if (snap.connectionState != ConnectionState.done) {
          return Container(color: Colors.black12);
        }
        if (bytes == null || bytes.isEmpty) {
          // Fallback to file with error guard
          return Image.file(
            item.file!,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const ColoredBox(color: Colors.black12),
          );
        }
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, _ ,_) => const ColoredBox(color: Colors.black12),
        );
      },
    );
  }

  // Default: display the file with an error fallback
  if (item.file != null) {
    return Image.file(
      item.file!,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const ColoredBox(color: Colors.black12),
    );
  }

  // Last resort
  return const ColoredBox(color: Colors.black12);
}

class _SliderCounter extends StatelessWidget {
  const _SliderCounter({required this.index, required this.total});

  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black54,
      ),
      child: Text(
        '${index + 1} / $total',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
