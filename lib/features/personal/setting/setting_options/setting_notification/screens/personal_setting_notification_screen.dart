import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'pages/personal_setting_email_notification_screen.dart';
import 'pages/personal_setting_push_notification.dart';

class PersonalSettingNotificationScreen extends StatefulWidget {
  const PersonalSettingNotificationScreen({super.key});
  static String routeName = '/personal-notification-setting';
  @override
  State<PersonalSettingNotificationScreen> createState() =>
      _PersonalSettingNotificationScreenState();
}

class _PersonalSettingNotificationScreenState
    extends State<PersonalSettingNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'notification'.tr(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            ListTile(
              onTap: () {
                Navigator.pushNamed(
                    context, PersonalSettingPushNotificationScreen.routeName);
              },
              title: Text('push_notifications'.tr()),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
              ),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                Navigator.pushNamed(
                    context, PersonalSettingEmailNotificationScreen.routeName);
              },
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
