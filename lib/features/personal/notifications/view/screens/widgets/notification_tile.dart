import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/loaders/notification_loader_list.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../chats/chat/views/providers/chat_provider.dart';
import '../../../../order/data/source/local/local_orders.dart';
import '../../../../order/domain/entities/order_entity.dart';
import '../../../../order/view/order_buyer_screen/screen/order_buyer_screen.dart';
import '../../../../order/view/screens/order_seller_screen.dart';
import '../../../../post/post_detail/views/screens/post_detail_screen.dart';
import '../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../data/source/local/local_notification.dart';
import '../../../domain/entities/notification_entity.dart';
import '../../provider/notification_provider.dart';

class NotificationTile extends StatefulWidget {
  const NotificationTile({required this.notification, super.key});

  final NotificationEntity notification;

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  void _openNotification(
    BuildContext context, {
    required ChatProvider chatProvider,
    required String? chatId,
    required String orderId,
    required String postId,
  }) {
    if (orderId.isNotEmpty) {
      final OrderEntity? order = LocalOrders().get(orderId);
      final String? uid = LocalAuth.uid;

      if (order != null && uid != null && uid.isNotEmpty) {
        if (uid == order.sellerId) {
          AppNavigator.pushNamed(
            OrderSellerScreen.routeName,
            arguments: <String, dynamic>{'order-id': orderId},
          );
          return;
        }

        if (uid == order.buyerId) {
          AppNavigator.pushNamed(
            OrderBuyerScreen.routeName,
            arguments: <String, dynamic>{'order': order},
          );
          return;
        }
      }

      final String notificationFor = widget.notification.notificationFor
          .toLowerCase();
      final bool forSeller =
          notificationFor.contains('seller') ||
          notificationFor.contains('business');

      if (forSeller) {
        AppNavigator.pushNamed(
          OrderSellerScreen.routeName,
          arguments: <String, dynamic>{'order-id': orderId},
        );
        return;
      }

      if (order != null) {
        AppNavigator.pushNamed(
          OrderBuyerScreen.routeName,
          arguments: <String, dynamic>{'order': order},
        );
        return;
      }

      AppSnackBar.showSnackBar(context, 'no_data_found'.tr());
      return;
    }

    if (postId.isNotEmpty) {
      AppNavigator.pushNamed(
        PostDetailScreen.routeName,
        arguments: <String, String>{'pid': postId},
      );
      return;
    }

    if (chatId != null && chatId.trim().isNotEmpty) {
      chatProvider.createOrOpenChatById(context, chatId);
      return;
    }

    AppSnackBar.showSnackBar(context, 'no_data_found'.tr());
  }

  @override
  Widget build(BuildContext context) {
    final ChatProvider chatProvider = Provider.of<ChatProvider>(
      context,
      listen: false,
    );

    final String? chatId = widget.notification.chatId;
    final String postId = (widget.notification.postId ?? '').trim();
    final String orderId = (widget.notification.orderId ?? '').trim();
    final bool isUnread = !widget.notification.isViewed;

    final String timeText = DateFormat(
      'dd MMM',
    ).format(widget.notification.timestamps.toLocal());

    final Color borderColor = Theme.of(context).colorScheme.outlineVariant;
    final Color unreadBg = Theme.of(
      context,
    ).colorScheme.primary.withValues(alpha: 0.06);

    final bool hasAnyAction =
        orderId.isNotEmpty ||
        postId.isNotEmpty ||
        (chatId?.trim().isNotEmpty ?? false);

    return FutureBuilder<UserEntity?>(
      future: LocalUser().user(widget.notification.userId),
      builder: (BuildContext context, AsyncSnapshot<UserEntity?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const NotificationLoaderTile();
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox();
        }

        final UserEntity user = snapshot.data!;

        return InkWell(
          onTap: () async {
            await LocalNotifications.markAsViewed(
              widget.notification.notificationId,
            );
            if (context.mounted) {
              context.read<NotificationProvider>().refreshFromLocal();
            }
            if (!context.mounted) return;
            _openNotification(
              context,
              chatProvider: chatProvider,
              chatId: chatId,
              orderId: orderId,
              postId: postId,
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isUnread ? unreadBg : null,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomNetworkImage(
                    imageURL: user.profilePhotoURL,
                    size: 52,
                    placeholder: user.displayName.isNotEmpty
                        ? user.displayName
                        : 'na'.tr(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              user.displayName.isNotEmpty
                                  ? user.displayName
                                  : 'na'.tr(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    fontWeight: isUnread
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            timeText,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: <Widget>[
                          if (isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          Expanded(
                            child: Text(
                              widget.notification.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.notification.message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasAnyAction) ...<Widget>[
                  const SizedBox(width: 8),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(0, 28),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () => _openNotification(
                      context,
                      chatProvider: chatProvider,
                      chatId: chatId,
                      orderId: orderId,
                      postId: postId,
                    ),
                    child: Text(
                      'view'.tr(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
