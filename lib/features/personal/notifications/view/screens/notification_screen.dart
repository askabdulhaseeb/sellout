import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_toggle_switch.dart';
import '../../../../../core/widgets/empty_page_widget.dart';
import '../../../../../core/widgets/loaders/notification_loader_list.dart';
import '../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../routes/app_linking.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../chats/chat/views/providers/chat_provider.dart';
import '../../../order/data/source/local/local_orders.dart';
import '../../../order/domain/entities/order_entity.dart';
import '../../../order/view/order_buyer_screen/screen/order_buyer_screen.dart';
import '../../../order/view/screens/order_seller_screen.dart';
import '../../../post/post_detail/views/screens/post_detail_screen.dart';
import '../../../user/profiles/data/sources/local/local_user.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/enums/notification_type.dart';
import 'package:provider/provider.dart';
import '../provider/notification_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  static String routeName = 'notification';

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotificationsByType();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: const AppBarTitle(titleKey: 'notifications'),
        centerTitle: true,
      ),
      body: Consumer<NotificationProvider>(
        builder: (BuildContext context, NotificationProvider provider, _) {
          final List<NotificationEntity> notifications = provider.notifications;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                CustomToggleSwitch<NotificationType>(
                  isShaded: false,
                  borderWidth: 1,
                  unseletedBorderColor: ColorScheme.of(context).outlineVariant,
                  unseletedTextColor: ColorScheme.of(context).onSurface,
                  borderRad: 6,
                  labels: NotificationType.values.toList(),
                  labelStrs: NotificationType.values
                      .map((NotificationType e) => e.code.tr())
                      .toList(),
                  labelText: '',
                  initialValue: provider.selectedNotificationType,
                  onToggle: (NotificationType value) {
                    provider.setNotificationType(value);
                  },
                  selectedColors: List<Color>.filled(
                    NotificationType.values.length,
                    Theme.of(context).primaryColor,
                  ),
                ),
                if (notifications.isEmpty)
                  Expanded(
                    child: Center(
                      child: EmptyPageWidget(
                        icon: CupertinoIcons.bell,
                        childBelow: Text(
                          'no_results'.tr(),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                if (notifications.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (BuildContext context, int index) {
                        return NotificationWidget(
                          notification: notifications[index],
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({required this.notification, super.key});

  final NotificationEntity notification;

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
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

      // Prefer a definitive role check using the order entity when available.
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

      // Fallback: use notificationFor hint when we can't determine role.
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
    final ChatProvider pro = Provider.of<ChatProvider>(context, listen: false);
    final Map<String, dynamic> metadata = widget.notification.metadata;
    final String? chatId = metadata['chat_id'] as String?;
    final String postId = (metadata['post_id'] as String?)?.trim() ?? '';
    final String orderId = (metadata['order_id'] as String?)?.trim() ?? '';

    return FutureBuilder<UserEntity?>(
      future: LocalUser().user(widget.notification.userId),
      builder: (BuildContext context, AsyncSnapshot<UserEntity?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const NotificationLoaderTile();
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox();
        }
        final UserEntity? user = snapshot.data;
        final bool hasAnyAction =
            orderId.isNotEmpty ||
            postId.isNotEmpty ||
            (chatId != null && chatId.trim().isNotEmpty);
        return InkWell(
          onTap: () => _openNotification(
            context,
            chatProvider: pro,
            chatId: chatId,
            orderId: orderId,
            postId: postId,
          ),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CustomNetworkImage(
                    imageURL: user?.profilePhotoURL ?? '',
                    size: 60,
                    placeholder: user?.displayName.isNotEmpty == true
                        ? user!.displayName
                        : 'na'.tr(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user?.displayName ?? 'na'.tr(),
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(),
                      ),
                      Text(
                        widget.notification.title,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasAnyAction)
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
                      chatProvider: pro,
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
            ),
          ),
        );
      },
    );
  }
}
