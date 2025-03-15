import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import '../providers/review_provider.dart';

class MediaGridWidget extends StatelessWidget {
  const MediaGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ReviewProvider provider = Provider.of<ReviewProvider>(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: provider.assets.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 1, // Forces square shape
              ),
              itemBuilder: (BuildContext context, int index) {
                if (index >= provider.assets.length)
                  return const SizedBox(); // Prevents out-of-range error

                final AssetEntity asset = provider.assets[
                    index]; // Now it's safe    final AssetEntity asset = provider.assets[index];
                final bool isSelected = provider.selectedMedia.contains(asset);
                return GestureDetector(
                  onTap: () {
                    provider.toggleMediaSelection(asset);
                  },
                  child: Stack(
                    children: <Widget>[
                      FutureBuilder<Uint8List?>(
                        future: asset.thumbnailDataWithSize(
                            const ThumbnailSize(150, 150)),
                        builder: (BuildContext context,
                            AsyncSnapshot<Uint8List?> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasData) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  10), // Smooth rounded corners
                              child: SizedBox(
                                width: double.infinity,
                                height: double
                                    .infinity, // Ensures equal space usage
                                child: Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit
                                      .cover, // Makes images fill the square space
                                ),
                              ),
                            );
                          }
                          return const Center(child: Text('Error'));
                        },
                      ),
                      if (isSelected)
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: colorScheme.primary, width: 4),
                            color: colorScheme.primary.withAlpha(100),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
