import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PersonalSettingEmailNotificationScreen extends StatefulWidget {
  const PersonalSettingEmailNotificationScreen({super.key});
  static String routeName = '/email_notification';
  @override
  State<PersonalSettingEmailNotificationScreen> createState() =>
      _PersonalSettingEmailNotificationScreenState();
}

class _PersonalSettingEmailNotificationScreenState
    extends State<PersonalSettingEmailNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'email_notifications'.tr(),
        ),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[],
        ),
      ),
    );
  }
}
