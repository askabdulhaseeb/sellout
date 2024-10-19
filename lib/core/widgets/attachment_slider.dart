import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../features/attachment/domain/entities/attachment_entity.dart';
import 'custom_network_image.dart';

class AttachmentsSlider extends StatelessWidget {
  const AttachmentsSlider({
    required this.urls,
    this.aspectRatio = 4 / 3,
    this.width,
    this.height,
    super.key,
  });
  final List<AttachmentEntity> urls;
  final double aspectRatio;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: urls
          .map((AttachmentEntity proDetail) => _Attachment(
                url: proDetail,
                totalLength: urls.length,
                index: urls.indexOf(proDetail),
              ))
          .toList(),
      options: CarouselOptions(
        aspectRatio: 4 / 3,
        viewportFraction: 1,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
      ),
    );
  }
}

class _Attachment extends StatelessWidget {
  const _Attachment({
    required this.url,
    required this.totalLength,
    required this.index,
  });
  final AttachmentEntity url;
  final int totalLength;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: double.infinity,
            child: url.type == AttachmentType.video
                ?
                // Consumer<AppProvider>(
                //     builder: (_, AppProvider appPro, __) => NetworkVideoPlayer(
                //       url: url.url,
                //       isMute: appPro.isMute,
                //     ),
                //   )
                const Center(child: Text('Video'))
                : InteractiveViewer(
                    child: CustomNetworkImage(imageURL: url.url),
                  ),
          ),
          if (totalLength > 1 && index != 0)
            Positioned(
              top: 0,
              bottom: 0,
              left: 6,
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                ),
              ),
            ),
          if (totalLength > 1 && index < (totalLength - 1))
            Positioned(
              top: 0,
              bottom: 0,
              right: 6,
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                ),
              ),
            ),
          if (totalLength > 1)
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 8,
              ),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black45,
              ),
              child: Text(
                '${index + 1}/$totalLength',
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
