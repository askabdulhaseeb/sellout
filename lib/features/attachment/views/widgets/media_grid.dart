import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../core/constants/app_spacings.dart';
import '../../../../core/widgets/custom_shimmer_effect.dart';
import '../providers/picked_media_provider.dart';
import 'picked_media_display_tile.dart';

class MediaGrid extends StatelessWidget {
  const MediaGrid({
    required this.provider,
    required this.gridKey,
    required this.tileKeys,
    super.key,
  });
  final PickedMediaProvider provider;
  final GlobalKey gridKey;
  final Map<int, GlobalKey> tileKeys;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(AppSpacing.md),
      sliver: SliverGrid(
        key: gridKey,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: AppSpacing.xs,
          mainAxisSpacing: AppSpacing.xs,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (index >= provider.mediaList.length) {
              return const ShimmerLoading(isLoading: true, child: SizedBox());
            }
            final AssetEntity media = provider.mediaList[index];
            final Uint8List? thumb = provider.getThumbnail(media.id);

            // KEY ASSIGNMENT LOGIC:
            // Each grid tile gets a GlobalKey assigned by index
            // This key is used later to scroll to the tile when user taps it in the strip
            final GlobalKey newKey = tileKeys[index] ??= GlobalKey();

            return PickedMediaDisplayTile(
              key: newKey,
              media: media,
              thumbnail: thumb,
            );
          },
          childCount:
              provider.mediaList.length + (provider.isLoadingMore ? 6 : 0),
        ),
      ),
    );
  }
}
