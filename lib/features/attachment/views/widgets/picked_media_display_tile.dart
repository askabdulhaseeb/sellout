import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../providers/picked_media_provider.dart';

class PickedMediaDisplayTile extends StatelessWidget {
  const PickedMediaDisplayTile({required this.media, super.key});
  final AssetEntity media;

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Colors.black54;
    const double radius = 12;
    return FutureBuilder<Uint8List?>(
      future: media.thumbnailData,
      builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Consumer<PickedMediaProvider>(
              builder: (BuildContext context, PickedMediaProvider mediaPro, _) {
            return InkWell(
              onTap: () => mediaPro.onTap(media),
              child: Stack(
                children: <Widget>[
                  Image.memory(
                    height: double.infinity,
                    width: double.infinity,
                    snapshot.data!,
                    fit: BoxFit.cover,
                  ),
                  if (mediaPro.indexOf(media) != null)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: radius,
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: FittedBox(
                            child: Text(
                              mediaPro.indexOf(media) != null
                                  ? '${mediaPro.indexOf(media)! + 1}'
                                  : '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 6,
                    right: 6,
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: <Widget>[
                        if (media.type == AssetType.video)
                          const CircleAvatar(
                            backgroundColor: bgColor,
                            radius: radius,
                            child: Icon(
                              Icons.videocam,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        if (media.isFavorite)
                          const CircleAvatar(
                            backgroundColor: bgColor,
                            radius: radius,
                            child: Icon(
                              Icons.favorite,
                              size: 18,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        } else {
          return Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.grey[300],
          );
        }
      },
    );
  }
}
