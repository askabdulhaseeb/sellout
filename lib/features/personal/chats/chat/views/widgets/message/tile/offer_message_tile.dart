import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../post/data/sources/local/local_post.dart';
import '../../../../../../post/domain/entities/post_entity.dart';
import '../../../../../../post/feed/views/enums/offer_status_enum.dart';
import '../../../../../../post/feed/views/widgets/post/widgets/section/buttons/type/widgets/post_make_offer_button.dart';
import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import 'widgets/offer_status_button.dart';

class OfferMessageTile extends StatelessWidget {
  const OfferMessageTile({required this.message, super.key});
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostEntity?>(
        future: LocalPost().getPost(message.visitingDetail?.postID ??
            message.offerDetail?.post.postID ??
            ''),
        builder: (BuildContext context, AsyncSnapshot<PostEntity?> snapshot) {
          final PostEntity? post = snapshot.data;
          final String price = post?.priceStr ??
              message.offerDetail?.post.price.toString() ??
              'na'.tr();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: ShadowContainer(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CustomNetworkImage(
                              imageURL: message.postImage ?? ''),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              post?.title ??
                                  message.offerDetail?.post.title ??
                                  'na'.tr(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${message.offerDetail?.currency.toUpperCase()} $price',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  '${message.offerDetail?.currency.toUpperCase()} ${message.offerDetail?.offerPrice.toString()}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  price,
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(message.offerDetail?.offerStatus ?? 'na'.tr()),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (message.offerDetail?.offerStatus ==
                          OfferStatus.pending.value &&
                      message.sendBy != LocalAuth.currentUser?.userID)
                    OfferStatusButtons(message: message),
                  if (message.offerDetail?.offerStatus ==
                          OfferStatus.accept.value &&
                      message.sendBy == LocalAuth.currentUser?.userID)
                    CustomElevatedButton(
                        title: 'buy_now'.tr(), isLoading: false, onTap: () {}),
                  if (message.offerDetail?.offerStatus ==
                          OfferStatus.reject.value &&
                      message.sendBy == LocalAuth.currentUser?.userID)
                    Row(
                      children: <Widget>[
                        Expanded(child: PostMakeOfferButton(post: post!)),
                        Expanded(
                            child: CustomElevatedButton(
                                title: 'buy_now'.tr(),
                                isLoading: false,
                                onTap: () {})),
                      ],
                    )
                ],
              ),
            ),
          );
        });
  }
}
