import 'package:flutter/material.dart';
import '../../../../order/domain/entities/order_payment_detail_entity.dart';
import '../../../../post/data/sources/local/local_post.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../domain/entities/notification_entity.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';

class NotificationOrderHeader extends StatelessWidget {
  const NotificationOrderHeader({
    required this.notification,
    required this.timeText,
    required this.isUnread,
    super.key,
  });
  final NotificationEntity notification;
  final String timeText;
  final bool isUnread;

  @override
  Widget build(BuildContext context) {
    final String? postId = notification.postId;
    final paymentDetail = notification.metadata.paymentDetail;
    return FutureBuilder<UserEntity?>(
      future: _getOtherUser(context, paymentDetail),
      builder: (context, userSnapshot) {
        final user = userSnapshot.data;
        return FutureBuilder<PostEntity?>(
          future: postId != null
              ? LocalPost().getPost(postId)
              : Future.value(null),
          builder: (context, postSnapshot) {
            final post = postSnapshot.data;
            // Determine if current user is buyer or seller
            final currentUser = LocalAuth.currentUser;
            final isBuyer =
                currentUser != null &&
                paymentDetail != null &&
                currentUser.userID == paymentDetail.buyerCurrency;
            final price = paymentDetail != null
                ? (isBuyer ? paymentDetail.price : paymentDetail.convertedPrice)
                : null;
            final currency = paymentDetail != null
                ? (isBuyer
                      ? paymentDetail.buyerCurrency
                      : paymentDetail.postCurrency)
                : null;
            return Row(
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    if (post?.imageURL != null && post!.imageURL.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CustomNetworkImage(
                          imageURL: post.imageURL,
                          size: 48,
                          placeholder: post.title,
                        ),
                      ),
                    if (user != null)
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            padding: const EdgeInsets.all(1),
                            child: CustomNetworkImage(
                              imageURL: user.profilePhotoURL,
                              size: 20,
                              placeholder: user.displayName.isNotEmpty
                                  ? user.displayName
                                  : 'na',
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    post?.title ?? notification.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                ),
                if (price != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      '$price ${currency ?? ''}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Text(
                  timeText,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<UserEntity?> _getOtherUser(
    BuildContext context,
    OrderPaymentDetailEntity? paymentDetail,
  ) async {
    final currentUser = LocalAuth.currentUser;
    if (currentUser == null || paymentDetail == null) return null;
    // If current user is buyer, show seller; if seller, show buyer
    final isBuyer = currentUser.userID == paymentDetail.buyerCurrency;
    final otherUserId = isBuyer
        ? paymentDetail.sellerId
        : paymentDetail.buyerCurrency;
    return await LocalUser().user(otherUserId);
  }
}
