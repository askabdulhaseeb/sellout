import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/widgets/utils/in_dev_mode.dart';
import 'automatic_response_screen.dart';

class TimeAwayScreen extends StatelessWidget {
  const TimeAwayScreen({super.key});
  static const String routeName = '/time_away';

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text('time_away_title'.tr()), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: <Widget>[
          /// Schedule time away
          InDevMode(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'schedule_time_away'.tr(),
                    style: textTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    'schedule_time_away_subtitle'.tr(),
                    style: textTheme.bodySmall,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    //TODO:
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 16),
                  child: Text(
                    'none_scheduled'.tr(),
                    style: textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'automatic_response'.tr(),
                  style: textTheme.bodyLarge,
                ),
                subtitle: Text(
                  'automatic_response_subtitle'.tr(),
                  style: textTheme.bodySmall,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AutomaticResponseScreen.routeName,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 16),
                child: Text(
                  'no_message'.tr(),
                  style: textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),

          /// Feedback link
          InDevMode(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: GestureDetector(
                onTap: () {
                  // Action for feedback
                },
                child: Text(
                  'tell_us_what_you_think'.tr(),
                  style: textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
