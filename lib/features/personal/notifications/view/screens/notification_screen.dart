import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_toggle_switch.dart';
import '../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  static String routeName = 'notification';

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String selectedFilter = 'Orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: AppBarTitle(
          titleKey: 'notifications'.tr(),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          CustomToggleSwitch<String>(
            borderRad: 6,
            verticalPadding: 4,
            unseletedBorderColor: ColorScheme.of(context).outlineVariant,
            unseletedTextColor: ColorScheme.of(context).onSurface,
            isShaded: false,
            borderWidth: 1,
            seletedFontSize: 10,
            labels: <String>[
              'all'.tr(),
              'orders'.tr(),
              'services'.tr(),
              'requests'.tr(),
            ],
            labelStrs: const <String>['All', 'Orders', 'Services', 'Requests'],
            labelText: '',
            initialValue: selectedFilter,
            onToggle: (String value) {
              setState(() {
                selectedFilter = value;
              });
            },
            selectedColors: const <Color>[
              AppTheme.primaryColor,
              AppTheme.primaryColor,
              AppTheme.primaryColor,
              AppTheme.primaryColor,
            ],
          ),
          const SizedBox(height: 24),
          _buildNotificationTile(
            imageUrl: 'https://via.placeholder.com/60',
            title: 'Emma T.',
            message: 'Sold! Has bought “Flock”',
            onViewPressed: () {
              // View action
            },
          ),
          const SizedBox(height: 16),
          _buildNotificationTile(
            imageUrl: 'https://via.placeholder.com/60',
            title: 'John S.',
            message: 'Liked your product “Pixel”',
            onViewPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile({
    required String imageUrl,
    required String title,
    required String message,
    required VoidCallback onViewPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CustomNetworkImage(
              imageURL: imageUrl,
              size: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black87)),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: const TextStyle(
                      fontSize: 14, color: Colors.black54, height: 1.4),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 80,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: onViewPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'View',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
