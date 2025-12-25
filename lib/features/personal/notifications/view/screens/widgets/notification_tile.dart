import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/loaders/notification_loader_list.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../chats/chat/views/providers/chat_provider.dart';
import '../../../../order/view/order_buyer_screen/screen/order_buyer_screen.dart';
import '../../../../order/view/screens/order_seller_screen.dart';
import '../../../../post/post_detail/views/screens/post_detail_screen.dart';
import '../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../domain/entities/notification_entity.dart';
import '../../provider/notification_provider.dart';

class NotificationTile extends StatefulWidget {
  const NotificationTile({required this.notification, super.key});

  final NotificationEntity notification;

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  bool _hasBeenMarkedAsViewed = false;

  void _onVisibilityChanged(VisibilityInfo info) {
    // Mark as viewed when 50% or more of the tile is visible
    if (info.visibleFraction >= 0.5 &&
        !_hasBeenMarkedAsViewed &&
        !widget.notification.isViewed) {
      _hasBeenMarkedAsViewed = true;
      // Mark notification as viewed in background
      context.read<NotificationProvider>().viewSingleNotification(
        widget.notification.notificationId,
      );
    }
  }

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
    }
  }

  /// Handles order-related notifications
  Future<void> _handleOrderNotification(
    BuildContext context,
    String? orderId,
  ) async {
    if (orderId == null || orderId.isEmpty) {
      if (context.mounted) {
        AppSnackBar.showSnackBar(context, 'order_not_found'.tr());
      }
      return;
    }

    final String notificationFor = widget.notification.notificationFor
        .toLowerCase();
    final bool forSeller =
        notificationFor.contains('seller') ||
        notificationFor.contains('business');

    if (!context.mounted) return;

    if (forSeller) {
      AppNavigator.pushNamed(
        OrderSellerScreen.routeName,
        arguments: <String, dynamic>{'order-id': orderId},
      );
      return;
    }

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
      if (context.mounted) {
        AppSnackBar.showSnackBar(context, 'chat_not_found'.tr());
      }
      return;
    }

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
      if (context.mounted) {
        AppSnackBar.showSnackBar(context, 'post_not_found'.tr());
      }
      return;
    }

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
        return 'view'.tr();
    }
  }

  // UI helpers for modularization
  Widget _buildAvatar(UserEntity user) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CustomNetworkImage(
        imageURL: user.profilePhotoURL,
        size: 52,
        placeholder: user.displayName.isNotEmpty ? user.displayName : 'na'.tr(),
      ),
    );
  }

  Widget _buildHeader(UserEntity user, String timeText, bool isUnread) {
    return Row(
      children: <Widget>[
        Flexible(
          child: Text(
            user.displayName.isNotEmpty ? user.displayName : 'na'.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
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
  }

  Widget _buildTitleRow(bool isUnread) {
    return Row(
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
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessage() {
    return Text(
      widget.notification.message,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
      ),
    );
  }

  Widget _buildActionButton(bool hasAction) {
    if (!hasAction) return const SizedBox.shrink();
    return TextButton.icon(
      style: TextButton.styleFrom(
        minimumSize: const Size(0, 32),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      onPressed: () => _openNotification(context),
      label: Text(
        _getButtonText(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
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

        return VisibilityDetector(
          key: Key('notification_${widget.notification.notificationId}'),
          onVisibilityChanged: _onVisibilityChanged,
          child: InkWell(
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
                  _buildAvatar(user),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildHeader(user, timeText, isUnread),
                        const SizedBox(height: 2),
                        _buildTitleRow(isUnread),
                        const SizedBox(height: 2),
                        _buildMessage(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(hasAction),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
