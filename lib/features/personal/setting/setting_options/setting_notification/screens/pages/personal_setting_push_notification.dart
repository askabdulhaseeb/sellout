import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../core/widgets/custom_Switch_list_tile.dart';
import '../../../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../setting_dashboard/view/providers/personal_setting_provider.dart';

class PersonalSettingPushNotificationScreen extends StatelessWidget {
  const PersonalSettingPushNotificationScreen({super.key});
  static const String routeName = '/push_notification';

  @override
  Widget build(BuildContext context) {
    final PersonalSettingProvider provider =
        Provider.of<PersonalSettingProvider>(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('push_notification_title'.tr()),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: <Widget>[
          CustomSwitchListTile(
            title: 'enable_phone_notification'.tr(),
            value:
                LocalAuth.currentUser?.notification?.pushNotification ?? false,
            onChanged: (bool value) => provider.togglePushNotification(value),
          ),
          const Divider(),
          InDevMode(
            child: Column(
              children: <Widget>[
                CustomSwitchListTile(
                  title: 'sellout_updates'.tr(),
                  subtitle: 'sellout_updates_subtitle'.tr(),
                  value: provider.sellOutUpdates,
                  onChanged: provider.toggleSellOutUpdates,
                ),
                const Divider(),
                CustomSwitchListTile(
                  title: 'marketing_communications'.tr(),
                  subtitle: 'marketing_communications_subtitle'.tr(),
                  value: provider.marketingCommunications,
                  onChanged: provider.toggleMarketingCommunications,
                ),
                const Divider(),
                CustomSwitchListTile(
                  title: 'new_messages'.tr(),
                  value: provider.newMessages,
                  onChanged: provider.toggleNewMessages,
                ),
                const Divider(),
                CustomSwitchListTile(
                  title: 'new_feedback'.tr(),
                  value: provider.newFeedback,
                  onChanged: provider.toggleNewFeedback,
                ),
                const Divider(),
                CustomSwitchListTile(
                  title: 'reduced_items'.tr(),
                  value: provider.reducedItems,
                  onChanged: provider.toggleReducedItems,
                ),
                const Divider(),
                CustomSwitchListTile(
                  title: 'favourited_items'.tr(),
                  value: provider.favouritedItems,
                  onChanged: provider.toggleFavouritedItems,
                ),
                const Divider(),
                CustomSwitchListTile(
                  title: 'new_followers'.tr(),
                  value: provider.newFollowers,
                  onChanged: provider.toggleNewFollowers,
                ),
                const Divider(),
                CustomSwitchListTile(
                  title: 'new_items'.tr(),
                  value: provider.newItems,
                  onChanged: provider.toggleNewItems,
                ),
                const Divider(),
                CustomSwitchListTile(
                  title: 'mentions'.tr(),
                  value: provider.mentions,
                  onChanged: provider.toggleMentions,
                ),
                const Divider(),
                CustomSwitchListTile(
                  title: 'forum_messages'.tr(),
                  value: provider.forumMessages,
                  onChanged: provider.toggleForumMessages,
                ),
                const SizedBox(height: 12),
                ListTile(
                  title: Text(
                    'daily_limit_hint'.tr(),
                    style: textTheme.bodySmall,
                  ),
                  subtitle: Text(
                    'daily_limit_value'.tr(),
                    maxLines: 3,
                    style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
