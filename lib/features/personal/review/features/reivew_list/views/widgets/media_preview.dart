import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import '../providers/review_provider.dart';
import 'package:provider/provider.dart';

class MediaPreviewWidget extends StatefulWidget {
  const MediaPreviewWidget({super.key});

  @override
  State<MediaPreviewWidget> createState() => _MediaPreviewWidgetState();
}

class _MediaPreviewWidgetState extends State<MediaPreviewWidget> {
  @override
  Widget build(BuildContext context) {
    final ReviewProvider provider = Provider.of<ReviewProvider>(context);

    if (provider.selectedMedia.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      height: 250,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          PageView.builder(
            itemCount: provider.selectedMedia.length,
            onPageChanged: (int index) {
              provider.setCurrentIndex(index);
              provider.loadVideo(provider.selectedMedia[index]);
            },
            itemBuilder: (BuildContext context, int index) {
              final AssetEntity asset = provider.selectedMedia[index];
              return FutureBuilder<Uint8List?>(
                future:
                    asset.thumbnailDataWithSize(const ThumbnailSize(300, 300)),
                builder:
                    (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    return Stack(
                      children: <Widget>[
                        if (asset.type == AssetType.video &&
                            provider.videoController != null)
                          SizedBox(
                            height: 250,
                            width: double.infinity,
                            child: Center(
                              child:
                                  provider.videoController!.value.isInitialized
                                      ? AspectRatio(
                                          aspectRatio: provider.videoController!
                                              .value.aspectRatio,
                                          child: VideoPlayer(
                                              provider.videoController!),
                                        )
                                      : const CircularProgressIndicator(),
                            ),
                          )
                        else
                          Image.memory(snapshot.data!,
                              fit: BoxFit.cover, width: double.infinity),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () {
                              provider.toggleMediaSelection(asset);
                              setState(() {});
                            },
                            child: const CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.red,
                              child: Icon(Icons.close,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return const Center(child: Text('Error'));
                },
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                provider.selectedMedia.length,
                (int index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: provider.currentIndex == index ? 10 : 6,
                  height: provider.currentIndex == index ? 10 : 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: provider.currentIndex == index
                        ? Colors.blue
                        : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
