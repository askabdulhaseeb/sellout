import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../core/sources/api_call.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_toggle_switch.dart';
import '../../../../../core/widgets/empty_page_widget.dart';
import '../../../../../core/widgets/loaders/notification_loader_list.dart';
import '../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../chats/chat/views/providers/chat_provider.dart';
import '../../../user/profiles/data/sources/local/local_user.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/enums/notification_type.dart';
import 'package:provider/provider.dart';
import '../provider/notification_provider.dart';
import '../../../../../core/usecase/usecase.dart';

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
                    provider.fetchNotificationsByType();
                  },
                  selectedColors: List<Color>.filled(
                      NotificationType.values.length, AppTheme.primaryColor),
                ),
                if (notifications.isEmpty)
                  Expanded(
                    child: Center(
                        child: EmptyPageWidget(
                      icon: CupertinoIcons.bell,
                      childBelow: Text(
                        'no_results'.tr(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.5),
                            ),
                        textAlign: TextAlign.center,
                      ),
                    )),
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
  const NotificationWidget({
    required this.notification,
    super.key,
  });

  final NotificationEntity notification;

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  late Future<DataState<UserEntity?>> userFuture;

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.notification.type);
    final ChatProvider pro = Provider.of<ChatProvider>(context, listen: false);
    final Map<String, dynamic> metadata = widget.notification.metadata;
    final String? chatId = metadata['chat_id'] as String?;

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
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CustomNetworkImage(
                  imageURL: user?.profilePhotoURL ?? '',
                  size: 60,
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
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(),
                    ),
                    Text(
                      widget.notification.title,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.5),
                          ),
                    ),
                    Row(
                      children: <Widget>[
                        if (chatId != null)
                          CustomElevatedButton(
                            borderRadius: BorderRadius.circular(6),
                            margin: const EdgeInsets.all(2),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 4),
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                            title: 'view'.tr(),
                            isLoading: false,
                            onTap: () {
                              pro.createOrOpenChatById(context, chatId);
                            },
                          ),
                        // CustomElevatedButton(
                        //   margin: const EdgeInsets.all(3),
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 24, vertical: 4),
                        //   textStyle: Theme.of(context)
                        //       .textTheme
                        //       .bodySmall
                        //       ?.copyWith(
                        //           color:
                        //               Theme.of(context).colorScheme.onPrimary),
                        //   title: 'view'.tr(),
                        //   isLoading: false,
                        //   onTap: () {},
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
