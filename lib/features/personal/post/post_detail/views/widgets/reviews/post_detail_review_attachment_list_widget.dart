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
        if (attachments.isEmpty) return const SizedBox();

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: ColorScheme.of(context).outlineVariant)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomNetworkImage(
                    imageURL: attachments.first.url,
                    size: 50,
                  ),
                ),
              ),
              Row(
                spacing: 6,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'see_all_photos',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ).tr(),
                  const Icon(Icons.arrow_forward_ios_outlined, size: 12),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
