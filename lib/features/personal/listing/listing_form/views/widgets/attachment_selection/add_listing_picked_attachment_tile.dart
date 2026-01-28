import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/widgets/media/custom_network_image.dart';
import '../../../../../../../core/widgets/media/video_widget.dart';
import '../../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../providers/add_listing_form_provider.dart';

class ListingAttachmentTile extends StatelessWidget {
  const ListingAttachmentTile({super.key, this.attachment, this.imageUrl});

  final PickedAttachment? attachment;
  final AttachmentEntity? imageUrl;

  bool get isVideo {
    if (attachment != null) {
      return attachment!.type == AttachmentType.video;
    }
    if (imageUrl != null) {
      return imageUrl!.type == AttachmentType.video;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bool isLocal = attachment != null;
    final AddListingFormProvider pro = Provider.of<AddListingFormProvider>(
      context,
      listen: false,
    );
    final Object? videoSource = isLocal ? attachment?.file.uri : imageUrl?.url;
    return Padding(
      padding: const EdgeInsets.all(3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AspectRatio(
          aspectRatio: 4 / 4,
          child: Stack(
            children: <Widget>[
              _buildContent(context, isLocal, videoSource),
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    if (isLocal) {
                      pro.removePickedAttachment(attachment!);
                    } else {
                      if (imageUrl != null) {
                        pro.removeAttachmentEntity(imageUrl!);
                      }
                    }
                  },
                  child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: const Icon(Icons.delete, color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    bool isLocal,
    Object? videoSource,
  ) {
    final Color bg = Theme.of(context).colorScheme.outlineVariant;
    return Container(
      color: bg,
      height: double.infinity,
      width: double.infinity,
      child: isVideo
          ? _buildVideo(videoSource)
          : (isLocal
                ? _buildLocalImage(context, attachment!)
                : _buildRemoteImage(context, imageUrl?.url)),
    );
  }

  Widget _buildVideo(Object? source) {
    return VideoWidget(videoSource: source, play: false);
  }

  Widget _buildRemoteImage(BuildContext context, String? url) {
    AppLog.info('Render network image | url=$url', name: 'AttachmentSlider');
    return CustomNetworkImage(imageURL: url, fit: BoxFit.cover);
  }

  Widget _buildLocalImage(BuildContext context, PickedAttachment att) {
    final String path = att.file.path;
    final File f = File(path);
    final bool exists = f.existsSync();
    final int size = exists ? (f.lengthSync()) : -1;
    AppLog.info(
      'Render local image | path=$path exists=$exists size=$size',
      name: 'ListingAttachmentTile',
    );
    final String lower = path.toLowerCase();
    final bool looksHeic = lower.endsWith('.heic') || lower.endsWith('.heif');

    // If HEIC/HEIF and we have the original AssetEntity, render a JPEG thumbnail
    if (looksHeic && att.selectedMedia != null) {
      final AssetEntity media = att.selectedMedia!;
      AppLog.info(
        'Render thumbnail | assetId=${media.id} mime=${media.mimeType} favorite=${media.isFavorite}',
        name: 'PickedMediaDisplayTile',
      );
      return FutureBuilder<Uint8List?>(
        future: att.selectedMedia!.thumbnailDataWithSize(
          const ThumbnailSize(1000, 1000),
          quality: 90,
          format: ThumbnailFormat.jpeg,
        ),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snap) {
          if (snap.connectionState != ConnectionState.done) {
            return _loadingPlaceholder(context, isVideo: false);
          }
          final Uint8List? bytes = snap.data;
          if (bytes == null || bytes.isEmpty) {
            return _safeImageFile(path);
          }
          return Image.memory(
            bytes,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, __, ___) =>
                _errorPlaceholder(context, isVideo: false),
          );
        },
      );
    }

    // Default: display file with error fallback
    return _safeImageFile(path);
  }

  // --- Helpers: Placeholders & Safe File Image ---
  Widget _loadingPlaceholder(BuildContext context, {required bool isVideo}) {
    return Container(
      color: Colors.black12,
      alignment: Alignment.center,
      child: const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _errorPlaceholder(BuildContext context, {required bool isVideo}) {
    return Container(
      color: Colors.black12,
      alignment: Alignment.center,
      child: Icon(
        isVideo ? Icons.videocam_off : Icons.image_not_supported,
        color: Colors.black45,
      ),
    );
  }

  Widget _safeImageFile(String path) {
    final File f = File(path);
    if (!f.existsSync()) {
      // If file missing, show placeholder
      return Builder(
        builder: (BuildContext context) =>
            _errorPlaceholder(context, isVideo: false),
      );
    }
    return Image.file(
      f,
      fit: BoxFit.cover,
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
            return _errorPlaceholder(context, isVideo: false);
          },
    );
  }
}
