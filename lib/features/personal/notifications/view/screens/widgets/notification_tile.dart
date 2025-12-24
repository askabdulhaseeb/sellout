import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/loaders/notification_loader_list.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../chats/chat/views/providers/chat_provider.dart';
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
  /// Determines the primary action based on notification type
  String get _primaryAction {
    final String type = widget.notification.type.toLowerCase();

    // Post-related notifications (priority)
    if (type.contains('post') ||
        type.contains('like') ||
        type.contains('comment') ||
        type.contains('follow')) {
      return 'post';
    }

    // Chat/Message notifications
    if (type.contains('chat') || type.contains('message')) {
      return 'chat';
    }

    // Order-related notifications
    if (type.contains('order')) {
      return 'order';
    }

    // Fallback to first available
    if (widget.notification.hasPost) return 'post';
    if (widget.notification.hasChat) return 'chat';
    if (widget.notification.hasOrder) return 'order';

    return 'none';
  }

  /// Opens the appropriate screen based on notification content
  Future<void> _openNotification(BuildContext context) async {
    final String? chatId = widget.notification.chatId;
    final String? postId = widget.notification.postId;
    final String? orderId = widget.notification.orderId;

    // Mark as viewed
    await LocalNotifications.markAsViewed(widget.notification.notificationId);
    if (context.mounted) {
      context.read<NotificationProvider>().refreshFromLocal();
    }

    // Handle based on primary action
    if (!context.mounted) return;

    switch (_primaryAction) {
      case 'post':
        await _handlePostNotification(context, postId);
        break;
      case 'chat':
        await _handleChatNotification(context, chatId);
        break;
      case 'order':
        await _handleOrderNotification(context, orderId);
        break;
      default:
        print('❌ NO ACTION - No valid data found');
    }

    print('═══════════════════════════════════════════════════════');
  }

  /// Handles order-related notifications
  Future<void> _handleOrderNotification(
    BuildContext context,
    String? orderId,
  ) async {
    if (orderId == null || orderId.isEmpty) {
      print('❌ Order ID is empty');
      if (context.mounted) {
        AppSnackBar.showSnackBar(context, 'order_not_found'.tr());
      }
      return;
    }

    print('✅ Processing ORDER: $orderId');

    final String notificationFor = widget.notification.notificationFor
        .toLowerCase();
    final bool forSeller =
        notificationFor.contains('seller') ||
        notificationFor.contains('business');

    print('   notificationFor: "$notificationFor" | forSeller: $forSeller');

    if (!context.mounted) return;

    if (forSeller) {
      print('   ✅ Navigating to SELLER view');
      AppNavigator.pushNamed(
        OrderSellerScreen.routeName,
        arguments: <String, dynamic>{'order-id': orderId},
      );
      return;
    }

    print('   ✅ Navigating to BUYER view');
    AppNavigator.pushNamed(
      OrderBuyerScreen.routeName,
      arguments: <String, dynamic>{'order-id': orderId},
    );
  }

  /// Handles chat/message notifications
  Future<void> _handleChatNotification(
    BuildContext context,
    String? chatId,
  ) async {
    if (chatId == null || chatId.trim().isEmpty) {
      print('❌ Chat ID is empty');
      if (context.mounted) {
        AppSnackBar.showSnackBar(context, 'chat_not_found'.tr());
      }
      return;
    }

    print('✅ Opening CHAT: $chatId');

    if (!context.mounted) return;

    final ChatProvider chatProvider = context.read<ChatProvider>();
    await chatProvider.createOrOpenChatById(context, chatId);
  }

  /// Handles post-related notifications
  Future<void> _handlePostNotification(
    BuildContext context,
    String? postId,
  ) async {
    if (postId == null || postId.isEmpty) {
      print('❌ Post ID is empty');
      if (context.mounted) {
        AppSnackBar.showSnackBar(context, 'post_not_found'.tr());
      }
      return;
    }

    print('✅ Opening POST: $postId');
    if (context.mounted) {
      AppNavigator.pushNamed(
        PostDetailScreen.routeName,
        arguments: <String, String>{'pid': postId},
      );
    }
  }

  /// Gets the button text based on primary action
  String _getButtonText() {
    switch (_primaryAction) {
      case 'order':
        return 'order'.tr();
      case 'chat':
        return 'chat'.tr();
      case 'post':
        return 'view'.tr();
      default:
        return 'open'.tr();
    }
  }

  /// Gets the button icon based on primary action
  IconData? _getButtonIcon() {
    switch (_primaryAction) {
      case 'order':
        return Icons.receipt_long;
      case 'chat':
        return Icons.chat_bubble_outline;
      case 'post':
        return Icons.visibility_outlined;
      default:
        return Icons.arrow_forward;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isUnread = !widget.notification.isViewed;
    final String timeText = DateFormat(
      'dd MMM',
    ).format(widget.notification.timestamps.toLocal());

    final bool hasAction = _primaryAction != 'none';

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
          onTap: hasAction ? () => _openNotification(context) : null,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isUnread
                  ? Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.05)
                  : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: <Widget>[
                // User Avatar
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

                // Content
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // User name and time
                      Row(
                        children: <Widget>[
                          Flexible(
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

                      // Title with unread indicator
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
                                    fontWeight: isUnread
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),

                      // Message
                      Text(
                        widget.notification.message,
                        maxLines: 2,
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

                // Action Button
                if (hasAction) ...[
                  const SizedBox(width: 8),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(0, 32),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
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
                    onPressed: () => _openNotification(context),
                    icon: Icon(_getButtonIcon(), size: 16),
                    label: Text(
                      _getButtonText(),
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
