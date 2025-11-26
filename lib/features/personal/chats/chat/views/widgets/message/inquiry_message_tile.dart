import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../post/data/sources/local/local_post.dart';
import '../../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../post/feed/views/widgets/post/widgets/section/buttons/home_post_button_section.dart';
import '../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../../chat_dashboard/domain/entities/messages/message_post_detail_entity.dart';
import 'message_bg_widget.dart';

class InquiryMessageTile extends StatelessWidget {
  const InquiryMessageTile({required this.message, super.key});
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    final MessagePostDetailEntity? post = message.postDetail;
    final bool isMe = message.sendBy == LocalAuth.uid;
    return FutureBuilder<PostEntity?>(
      future: LocalPost().getPost(post?.postId ?? ''),
      builder: (BuildContext context, AsyncSnapshot<PostEntity?> snapshot) {
        final PostEntity? postEntity = snapshot.data;
        return MessageBgWidget(
          isMe: isMe,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (post != null) ...<Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (postEntity != null && postEntity.imageURL.isNotEmpty)
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                        child: CustomNetworkImage(
                          imageURL: postEntity.imageURL,
                          size: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(width: AppSpacing.hSm),
                    Expanded(
                      child: ShadowContainer(
                        padding: const EdgeInsets.all(AppSpacing.xs),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              message.text,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.vSm),
                // Title and price row
                Row(
                  children: <Widget>[
                    Expanded(
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
                    Text(
                      '${CountryHelper.currencySymbolHelper(post.currency)}${post.price}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ],
              // Action Buttons
              if (postEntity != null && postEntity.createdBy != LocalAuth.uid)
                PostButtonSection(
                  post: postEntity,
                  detailWidget: false,
                ),
            ],
          ),
        );
      },
    );
  }
}
