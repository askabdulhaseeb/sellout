import 'dart:io';
import 'package:flutter/material.dart';
import '../../features/attachment/domain/entities/attachment_entity.dart';
import '../../features/attachment/domain/entities/picked_attachment.dart';
import 'custom_network_image.dart';

class AttachmentsSlider extends StatelessWidget {
  const AttachmentsSlider({
    super.key,
    this.attachments,
    this.aspectRatio = 4 / 3,
    this.width,
    this.height,
  });

  final List<dynamic>? attachments;
  final double aspectRatio;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final int totalLength = attachments?.length ?? 0;

    final List<Widget> items = attachments!
        .asMap()
        .entries
        .map(
          (MapEntry<int, dynamic> entry) => entry.value is PickedAttachment
              ? _PickedAttachmentWidget(
                  file: (entry.value as PickedAttachment).file,
                  index: entry.key,
                  totalLength: totalLength,
                )
              : _AttachmentEntityWidget(
                  entity: (entry.value as AttachmentEntity),
                  index: entry.key,
                  totalLength: totalLength,
                ),
        )
        .toList();

    return SizedBox(
      height: 300, // Set fixed height or make it dynamic
      child: PageView(
        children: items,
      ),
    );
  }
}

class _AttachmentEntityWidget extends StatelessWidget {
  const _AttachmentEntityWidget({
    required this.entity,
    required this.index,
    required this.totalLength,
  });

  final AttachmentEntity entity;
  final int index;
  final int totalLength;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: double.infinity,
          child: entity.type == AttachmentType.video
              ? const Center(child: Text('Video'))
              : InteractiveViewer(
                  child: CustomNetworkImage(imageURL: entity.url),
                ),
        ),
        if (totalLength > 1) _SliderCounter(index: index, total: totalLength),
      ],
    );
  }
}

class _PickedAttachmentWidget extends StatelessWidget {
  const _PickedAttachmentWidget({
    required this.file,
    required this.index,
    required this.totalLength,
  });

  final File file;
  final int index;
  final int totalLength;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: double.infinity,
          child: InteractiveViewer(
            child: Image.file(file, fit: BoxFit.cover),
          ),
        ),
        if (totalLength > 1) _SliderCounter(index: index, total: totalLength),
      ],
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
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black45,
      ),
      child: Text(
        '${index + 1}/$total',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
