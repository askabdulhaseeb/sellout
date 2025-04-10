import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PersonalSettingPushNotificationScreen extends StatefulWidget {
  const PersonalSettingPushNotificationScreen({super.key});
  static String routeName = '/personal-notification-setting-push';
  @override
  State<PersonalSettingPushNotificationScreen> createState() =>
      _PersonalSettingPushNotificationScreenState();
}

class _PersonalSettingPushNotificationScreenState
    extends State<PersonalSettingPushNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'push_notifications'.tr(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('push_notifications'.tr()),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
              ),
            ),
            const Divider(),
            ListTile(
              title: Text('email_notifications'.tr()),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
              ),
            )
          ],
        ),
      ),
    );
  }
}
