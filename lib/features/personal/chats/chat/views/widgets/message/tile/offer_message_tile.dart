import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../post/data/sources/local/local_post.dart';
import '../../../../../../post/domain/entities/post_entity.dart';
import '../../../../../../post/feed/views/enums/offer_status_enum.dart';
import '../../../../../../post/feed/views/providers/feed_provider.dart';
import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import 'widgets/offer_status_button.dart';

class OfferMessageTile extends HookWidget {
  const OfferMessageTile({required this.message, super.key});
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    final FeedProvider pro = Provider.of<FeedProvider>(context, listen: false);
    debugPrint(message.offerDetail?.offerId);
    final ValueNotifier<PostEntity?> post = useState<PostEntity?>(null);
    final ValueNotifier<String?> offerStatus =
        useState<String?>(message.offerDetail?.offerStatus);
    useEffect(() {
      LocalPost()
          .getPost(message.visitingDetail?.postID ??
              message.offerDetail?.post.postID ??
              '')
          .then((PostEntity? fetchedPost) {
        post.value = fetchedPost;
      });
      return null;
    }, <Object?>[]);
    useEffect(() {
      final String? updatedStatus = message.offerDetail?.offerStatus;
      if (offerStatus.value != updatedStatus) {
        offerStatus.value = updatedStatus;
      }

      return null;
    }, <Object?>[message.offerDetail?.offerStatus]);

    final String price = post.value?.priceStr ??
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
                    child:
                        CustomNetworkImage(imageURL: message.postImage ?? ''),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          post.value?.title ??
                              message.offerDetail?.post.title ??
                              'na'.tr(),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${message.offerDetail?.currency.toUpperCase()} $price',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
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
                            maxLines: 2,
                            '${message.offerDetail?.currency.toUpperCase()} ${message.offerDetail?.offerPrice.toString()}',
                            style: TextTheme.of(context)
                                .labelSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            price,
                            style: TextTheme.of(context).labelSmall?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(message.offerDetail?.offerStatus ?? 'na'.tr()),
                    ],
                  ),
                ),
              ],
            ),
            if (offerStatus.value == OfferStatus.pending.value &&
                message.sendBy != LocalAuth.currentUser?.userID)
              OfferStatusButtons(message: message),
            if (message.sendBy == LocalAuth.currentUser?.userID)
              Row(
                children: <Widget>[
                  CustomElevatedButton(
                      title: 'cancel'.tr(),
                      isLoading: pro.isLoading,
                      onTap: () => pro.updateOffer(
                            offerStatus: 'cancel',
                            messageID: message.messageId,
                            chatId: '',
                            context: context,
                            offerId: '',
                            businessId: '',
                            minoffer: 0,
                            offerAmount: 0,
                            quantity: 0,
                            color: '',
                          )),
                  if (offerStatus.value == OfferStatus.accept.value &&
                      message.sendBy == LocalAuth.currentUser?.userID)
                    CustomElevatedButton(
                      title: 'buy_now'.tr(),
                      isLoading: false,
                      onTap: () {},
                    ),
                ],
              ),
            if (offerStatus.value == OfferStatus.reject.value &&
                message.sendBy == LocalAuth.currentUser?.userID)
              Row(
                children: <Widget>[
                  Expanded(
                    child: CustomElevatedButton(
                      title: 'buy_now'.tr(),
                      isLoading: false,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
