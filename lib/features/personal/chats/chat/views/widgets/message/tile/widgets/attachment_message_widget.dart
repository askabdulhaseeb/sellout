import 'package:flutter/material.dart';

import '../../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../../../core/widgets/video_widget.dart';
import '../../../../../../../../attachment/domain/entities/attachment_entity.dart';

class AttachmentMessageWidget extends StatelessWidget {
  const AttachmentMessageWidget({required this.attachments, super.key});
  final List<AttachmentEntity> attachments;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: attachments.length < 3 ? 2 : 1,
      child: GridView.builder(
        itemCount: attachments.length > 4 ? 4 : attachments.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return attachments[index].type == AttachmentType.image
              ? CustomNetworkImage(imageURL: attachments[index].url)
              : attachments[index].type == AttachmentType.video
                  ? VideoWidget(videoUrl: attachments[index].url, play: false)
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          const Expanded(
                            child: Icon(
                              Icons.document_scanner_outlined,
                              size: 64,
                            ),
                          ),
                          Text(
                            attachments[index].originalName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
        },
      ),
    );
  }
}
