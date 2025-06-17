import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_toggle_switch.dart';

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
      appBar: AppBar(
        title: Text(
          'notifications'.tr(),
          style: TextTheme.of(context).titleMedium,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            CustomToggleSwitch<String>(
              seletedFontSize: 10,
              labels: <String>[
                'all'.tr(),
                'orders'.tr(),
                'services'.tr(),
                'requestssss'.tr()
              ],
              labelStrs: const <String>[
                'All',
                'Orders',
                'Services',
                'Requests'
              ],
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
            const SizedBox(
              height: 16,
              width: double.infinity,
            ),
            _buildNotificationTile(
              imageUrl: 'https://via.placeholder.com/60', // Replace with actual
              title: 'Emma T.',
              message: 'Sold! Has bought “Flock”',
              onViewPressed: () {
                // Your view logic
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTile({
    required String imageUrl,
    required String title,
    required String message,
    required VoidCallback onViewPressed,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CustomNetworkImage(
            imageURL: imageUrl,
            size: 60,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(
                message,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 70,
                height: 30,
                child: ElevatedButton(
                  onPressed: onViewPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text('View'),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
