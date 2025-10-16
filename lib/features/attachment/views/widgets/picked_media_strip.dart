import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import '../providers/picked_media_provider.dart';

class PickedMediaStrip extends StatelessWidget {
  const PickedMediaStrip({
    required this.onItemTap,
    super.key,
  });
  final void Function(int index) onItemTap;

  @override
  Widget build(BuildContext context) {
    return Consumer<PickedMediaProvider>(
      builder: (BuildContext context, PickedMediaProvider provider, _) {
        return AnimatedOpacity(
          opacity: provider.pickedMedia.isEmpty ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          child: AnimatedContainer(
            width: double.infinity,
            duration: const Duration(milliseconds: 300),
            height: provider.pickedMedia.isEmpty ? 0 : 48,
            child: provider.pickedMedia.isEmpty
                ? const SizedBox.shrink()
                : Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    child: ListView.builder(
                      key: const PageStorageKey<String>('picked_media_strip'),
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.pickedMedia.length,
                      itemBuilder: (BuildContext context, int index) {
                        final AssetEntity media = provider.pickedMedia[index];
                        final Uint8List? thumb =
                            provider.getThumbnail(media.id);
                        return GestureDetector(
                          key: ValueKey<AssetEntity>(media),
                          onTap: () {
                            print(
                                '🔷 Strip item tapped - index: $index, assetId: ${media.id}');
                            onItemTap(index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: thumb == null
                                  ? Container(
                                      width: 40,
                                      height: 40,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceVariant
                                          .withOpacity(0.3),
                                    )
                                  : Image.memory(
                                      thumb,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        );
      },
    );
  }
}
