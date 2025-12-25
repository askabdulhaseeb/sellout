import 'package:flutter/material.dart';
import '../../../../order/data/source/local/local_orders.dart';
import '../../../../order/domain/entities/order_entity.dart';
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
    final String? orderId = notification.orderId;
    return FutureBuilder<OrderEntity?>(
      future: orderId != null
          ? LocalOrders().fetchOrder(orderId)
          : Future.value(null),
      builder: (context, orderSnapshot) {
        final order = orderSnapshot.data;
        final otherUserId = _getOtherUserId(order);
        return FutureBuilder<UserEntity?>(
          future: otherUserId != null
              ? LocalUser().user(otherUserId)
              : Future.value(null),
          builder: (context, userSnapshot) {
            final user = userSnapshot.data;
            return FutureBuilder<PostEntity?>(
              future: postId != null
                  ? LocalPost().getPost(postId)
                  : Future.value(null),
              builder: (context, postSnapshot) {
                final post = postSnapshot.data;
                final price = order?.paymentDetail.price ?? order?.price;
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
                                color: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
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
                          '${price.toString()} ${order?.paymentDetail.postCurrency ?? ''}',
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
      },
    );
  }

  String? _getOtherUserId(OrderEntity? order) {
    if (order == null) return null;
    final CurrentUserEntity? currentUser = LocalAuth.currentUser;
    if (currentUser == null) return null;
    if (order.buyerId == currentUser.userID) {
      return order.sellerId;
    } else {
      return order.buyerId;
    }
  }
}
