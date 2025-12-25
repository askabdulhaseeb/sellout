import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/loaders/notification_loader_list.dart';
import '../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../domain/entities/notification_entity.dart';
import '../../provider/notification_provider.dart';
import 'notification_chat_action.dart';
import 'notification_order_action.dart';
import 'notification_post_action.dart';
import 'notification_order_header.dart';
import 'notification_order_message.dart';
import 'notification_chat_header.dart';
import 'notification_chat_message.dart';
import 'notification_post_header.dart';
import 'notification_post_message.dart';

class NotificationTile extends StatefulWidget {
  const NotificationTile({required this.notification, super.key});

  final NotificationEntity notification;

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  bool _hasBeenMarkedAsViewed = false;

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction >= 0.5 &&
        !_hasBeenMarkedAsViewed &&
        !widget.notification.isViewed) {
      _hasBeenMarkedAsViewed = true;
      context.read<NotificationProvider>().viewSingleNotification(
        widget.notification.notificationId,
      );
    }
  }

  String get _primaryAction {
    final String type = widget.notification.type.toLowerCase();

    if (type.contains('post') ||
        type.contains('like') ||
        type.contains('comment') ||
        type.contains('follow') ||
        widget.notification.hasPost) {
      return 'post';
    }
    if (type.contains('chat') ||
        type.contains('message') ||
        widget.notification.hasChat) {
      return 'chat';
    }
    if (type.contains('order') || widget.notification.hasOrder) {
      return 'order';
    }
    return 'none';
  }

  Future<void> _handleAction() async {
    if (!context.mounted) return;

    switch (_primaryAction) {
      case 'post':
        await NotificationPostAction.navigate(
          context: context,
          postId: widget.notification.postId,
        );
      case 'chat':
        await NotificationChatAction.navigate(
          context: context,
          chatId: widget.notification.chatId,
        );
      case 'order':
        await NotificationOrderAction.navigate(
          context: context,
          orderId: widget.notification.orderId,
          notificationFor: widget.notification.notificationFor,
        );
      default:
        break;
    }
  }

  Future<void> _handleDelete(BuildContext context) async {
    final bool success = await context
        .read<NotificationProvider>()
        .deleteNotifications(<String>[widget.notification.notificationId]);

    if (context.mounted) {
      if (success) {
        AppSnackBar.showSnackBar(context, 'notification_deleted'.tr());
      } else {
        AppSnackBar.showSnackBar(context, 'failed_to_delete'.tr());
      }
    }
  }

  String _getButtonText() => switch (_primaryAction) {
    'order' => NotificationOrderAction.getButtonText(),
    'chat' => NotificationChatAction.getButtonText(),
    _ => NotificationPostAction.getButtonText(),
  };

  Widget _buildAvatar(UserEntity user) => ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: CustomNetworkImage(
      imageURL: user.profilePhotoURL,
      size: 52,
      placeholder: user.displayName.isNotEmpty ? user.displayName : 'na'.tr(),
    ),
  );

  Widget _buildHeader(UserEntity user, String timeText, bool isUnread) {
    switch (_primaryAction) {
      case 'order':
        return NotificationOrderHeader(
          notification: widget.notification,
          timeText: timeText,
          isUnread: isUnread,
        );
      case 'chat':
        return NotificationChatHeader(
          notification: widget.notification,
          timeText: timeText,
          isUnread: isUnread,
        );
      case 'post':
        return NotificationPostHeader(
          notification: widget.notification,
          timeText: timeText,
          isUnread: isUnread,
        );
      default:
        return Row();
    }
  }

  Widget _buildMessage() {
    switch (_primaryAction) {
      case 'order':
        return NotificationOrderMessage(notification: widget.notification);
      case 'chat':
        return NotificationChatMessage(notification: widget.notification);
      case 'post':
        return NotificationPostMessage(notification: widget.notification);
      default:
        return Text(widget.notification.message);
    }
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
      onPressed: _handleAction,
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
        if (!snapshot.hasData) return const SizedBox();

        final UserEntity user = snapshot.data!;
        return VisibilityDetector(
          key: Key('notification_${widget.notification.notificationId}'),
          onVisibilityChanged: _onVisibilityChanged,
          child: Slidable(
            key: ValueKey(widget.notification.notificationId),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              dismissible: DismissiblePane(
                onDismissed: () => _handleDelete(context),
              ),
              children: <Widget>[
                SlidableAction(
                  onPressed: (BuildContext _) => _handleDelete(context),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                  icon: Icons.delete_outline,
                  label: 'delete'.tr(),
                ),
              ],
            ),
            child: InkWell(
              onTap: hasAction ? _handleAction : null,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildHeader(user, timeText, isUnread),
                          const SizedBox(height: 4),
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
          ),
        );
      },
    );
  }
}
