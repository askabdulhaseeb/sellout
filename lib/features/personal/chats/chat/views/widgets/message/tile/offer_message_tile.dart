import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../post/data/sources/local/local_post.dart';
import '../../../../../../post/domain/entities/post_entity.dart';
import '../../../../../../post/feed/views/enums/offer_status_enum.dart';
import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import 'widgets/offer_status_button.dart';

class OfferMessageTile extends HookWidget {
  const OfferMessageTile({required this.message, super.key});
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    debugPrint(message.offerDetail?.offerId);
    // Hook for post data state management
    final ValueNotifier<PostEntity?> post = useState<PostEntity?>(null);
    // Hook for monitoring changes to the offer status
    final ValueNotifier<String?> offerStatus =
        useState<String?>(message.offerDetail?.offerStatus);
    // Effect to fetch post data when widget is first built
    useEffect(() {
      // Fetch the post data from the local database
      LocalPost()
          .getPost(message.visitingDetail?.postID ??
              message.offerDetail?.post.postID ??
              '')
          .then((PostEntity? fetchedPost) {
        post.value = fetchedPost; // Update state when data is fetched
      });
      // Return cleanup function (optional in this case, as no cleanup is required)
      return null;
    }, <Object?>[]);
    // Effect to monitor and rebuild when offer status changes
    useEffect(() {
      // Assuming there is a method that updates the offer status locally
      final String? updatedStatus = message.offerDetail?.offerStatus;
      if (offerStatus.value != updatedStatus) {
        offerStatus.value =
            updatedStatus; // Update the state if status has changed
      }

      // Return cleanup function if needed
      return null;
    }, <Object?>[
      message.offerDetail?.offerStatus
    ]); // Dependency on offerStatus change

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
            // Rebuild widget based on offerStatus value
            if (offerStatus.value == OfferStatus.pending.value &&
                message.sendBy != LocalAuth.currentUser?.userID)
              OfferStatusButtons(message: message),
            if (offerStatus.value == OfferStatus.accept.value &&
                message.sendBy == LocalAuth.currentUser?.userID)
              CustomElevatedButton(
                title: 'buy_now'.tr(),
                isLoading: false,
                onTap: () {},
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
