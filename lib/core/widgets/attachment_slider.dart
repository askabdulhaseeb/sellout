import 'package:flutter/material.dart';
import '../../features/attachment/domain/entities/attachment_entity.dart';
import 'custom_network_image.dart';
import 'video_widget.dart';

class AttachmentsSlider extends StatefulWidget {
  const AttachmentsSlider({
    required this.attachments,
    super.key,
    this.aspectRatio = 4 / 3,
    this.width,
    this.height,
  });

  final List<AttachmentEntity> attachments;
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
    if (widget.attachments.isEmpty) {
      return const SizedBox();
    }

    final int totalLength = widget.attachments.length;

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
              final AttachmentEntity entity = widget.attachments[index];

              return SizedBox.expand(
                child: entity.type == AttachmentType.video
                    ? VideoWidget(videoSource: entity.url, play: true)
                    : InteractiveViewer(
                        child: CustomNetworkImage(
                          imageURL: entity.url,
                          fit: BoxFit.cover,
                        ),
                      ),
              );
            },
          ),
          if (totalLength > 1)
            Positioned(
              top: 8,
              right: 8,
              child: _SliderCounter(
                index: _currentIndex,
                total: totalLength,
              ),
            ),
        ],
      ),
    );
  }
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
