
import 'package:flutter/material.dart';

import '../../../../../../../../core/widgets/video_widget.dart';

class PromoItemCard extends StatelessWidget {
  const PromoItemCard({
    required this.title,
    required this.file,
    super.key,
  });

  final String title;
  final String file;

  bool isVideo(String url) {
    final String lower = url.toLowerCase();
    return lower.endsWith('.mp4') ||
           lower.endsWith('.mov') ||
           lower.endsWith('.webm') ||
           lower.endsWith('.avi');
  }

  @override
  Widget build(BuildContext context) {
    return Container(margin:const EdgeInsets.symmetric( horizontal:6),
      width: 80,
      child: Column(
        children: <Widget>[
          Container(
            width: 80,
            height: 100,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(border: Border.all(color:Theme.of(context).dividerColor),
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: <Widget>[
                  Image.network(
                    file,
                    fit: BoxFit.cover,
                    width: 80,
                    height: 100,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                  ),
                  if (isVideo(file))
                     Positioned.fill(
                      child: VideoWidget(videoSource: file,play: false,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(maxLines: 1,
            title,
            style: TextTheme.of(context).bodySmall,
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
