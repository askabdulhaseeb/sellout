import 'package:flutter/material.dart';
import '../../../../order/domain/entities/order_payment_detail_entity.dart';
import '../../../../post/data/sources/local/local_post.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../domain/entities/notification_entity.dart';
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
    final OrderPaymentDetailEntity? paymentDetail =
        notification.metadata.paymentDetail;
    return FutureBuilder<UserEntity?>(
      future: _getOtherUser(context, paymentDetail),
      builder: (BuildContext context, AsyncSnapshot<UserEntity?> userSnapshot) {
        return FutureBuilder<PostEntity?>(
          future: postId != null
              ? LocalPost().getPost(postId)
              : Future<PostEntity?>.value(null),
          builder:
              (BuildContext context, AsyncSnapshot<PostEntity?> postSnapshot) {
                final PostEntity? post = postSnapshot.data;
                // Determine if current user is buyer or seller
                final CurrentUserEntity? currentUser = LocalAuth.currentUser;
                final bool isSeller =
                    currentUser != null &&
                    paymentDetail != null &&
                    currentUser.userID == paymentDetail.sellerId;
                final double? price = paymentDetail != null
                    ? (isSeller
                          ? paymentDetail.convertedPrice
                          : paymentDetail.price)
                    : null;
                final String? currency = paymentDetail != null
                    ? (isSeller
                          ? paymentDetail.postCurrency
                          : paymentDetail.buyerCurrency)
                    : null;
                return Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        post?.title ?? notification.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: isUnread
                              ? FontWeight.w700
                              : FontWeight.w600,
                        ),
                      ),
                    ),
                    if (price != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          '$price ${currency ?? ''}',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
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
    final CurrentUserEntity? currentUser = LocalAuth.currentUser;
    if (currentUser == null || paymentDetail == null) return null;
    // If current user is buyer, show seller; if seller, attempt to show buyer
    final bool isSeller = currentUser.userID == paymentDetail.sellerId;
    final String otherUserId = isSeller
        // For seller, prefer senderId from notification metadata as buyer id
        ? notification.senderId ?? notification.userId
        : paymentDetail.sellerId;
    if (otherUserId.isEmpty) return null;
    return await LocalUser().user(otherUserId);
  }
}
