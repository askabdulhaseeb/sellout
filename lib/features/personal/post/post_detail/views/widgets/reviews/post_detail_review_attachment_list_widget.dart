import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../providers/post_detail_provider.dart';

class PostDetailReviewAttachmentListWidget extends StatelessWidget {
  const PostDetailReviewAttachmentListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PostDetailProvider>(
      builder: (BuildContext context, PostDetailProvider detailPro, _) {
        final List<AttachmentEntity> attachments = detailPro.reviewAttachments;
        return attachments.isEmpty
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Text(
                          'sell-all-photos-and-video',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_ios_outlined, size: 12),
                      ],
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        primary: false,
                        shrinkWrap: true,
                        itemCount: attachments.length,
                        itemBuilder: (BuildContext context, int index) {
                          final AttachmentEntity attachment =
                              attachments[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CustomNetworkImage(
                                imageURL: attachment.url,
                                size: 90,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
