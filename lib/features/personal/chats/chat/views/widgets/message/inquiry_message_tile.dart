import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../post/data/sources/local/local_post.dart';
import '../../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../post/feed/views/widgets/post/widgets/section/buttons/home_post_button_section.dart';
import '../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../../chat_dashboard/domain/entities/messages/message_post_detail_entity.dart';

class InquiryMessageTile extends StatelessWidget {
  const InquiryMessageTile({required this.message, super.key});
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    final MessagePostDetailEntity? post = message.postDetail;

    return FutureBuilder<PostEntity?>(
      future: LocalPost().getPost(post?.postId ?? ''),
      builder: (BuildContext context, AsyncSnapshot<PostEntity?> snapshot) {
        final PostEntity? postEntity = snapshot.data;

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (post != null) ...<Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (postEntity != null && postEntity.imageURL.isNotEmpty)
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 12.0, bottom: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CustomNetworkImage(
                            imageURL: postEntity.imageURL,
                            size: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  post.title ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Spacer(),
                              if (post.price != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${post.currency ?? ''}${post.price}',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                          if (postEntity != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Text(
                                postEntity.type.code.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],

              // Message Bubble
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message.text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),

              const SizedBox(height: 12),

              // Action Buttons
              if (postEntity != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: PostButtonSection(
                    post: postEntity,
                    detailWidget: false,
                  ),
                ),

              // Price bottom-right
              if (post != null && post.price != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0, right: 2.0),
                    child: Text(
                      '${post.currency ?? ''}${post.price}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700]),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
