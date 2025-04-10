import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';

class PostDetailAttachmentSlider extends StatefulWidget {
  const PostDetailAttachmentSlider({
    required this.urls,
    super.key,
  });

  final List<AttachmentEntity> urls;

  @override
  State<PostDetailAttachmentSlider> createState() =>
      _PostDetailAttachmentSliderState();
}

class _PostDetailAttachmentSliderState
    extends State<PostDetailAttachmentSlider> {
  int selectedIndex = 0; // To track selected image index

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Prevents unbounded height issue
      children: <Widget>[
        SizedBox(
          height: 250,
          width: double.infinity,
          child: widget.urls[selectedIndex].type == AttachmentType.video
              ? Center(child: Text('video_preview'.tr()))
              : InteractiveViewer(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomNetworkImage(
                          imageURL: widget.urls[selectedIndex].url)),
                ),
        ),

        const SizedBox(height: 10),
        // Thumbnails
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.urls.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selectedIndex == index
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child:
                          CustomNetworkImage(imageURL: widget.urls[index].url)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
