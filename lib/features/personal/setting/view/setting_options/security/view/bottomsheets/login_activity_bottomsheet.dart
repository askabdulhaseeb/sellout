import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../core/theme/app_theme.dart';
import '../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../auth/signin/domain/entities/login_info_entity.dart';

class LoginActivityScreen extends StatelessWidget {
  const LoginActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DeviceLoginInfoEntity> loginActivityList =
        LocalAuth.currentUser?.loginActivity ?? <DeviceLoginInfoEntity>[];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('login_activity'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ListView.separated(
          itemCount: loginActivityList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (BuildContext context, int index) {
            return LoginActivityTile(item: loginActivityList[index]);
          },
        ),
      ),
    );
  }
}

class LoginActivityTile extends StatelessWidget {
  const LoginActivityTile({super.key, required this.item});

  final DeviceLoginInfoEntity item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: ColorScheme.of(context).outlineVariant)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              spacing: 2,
              children: <Widget>[
                Text('${'device_name'.tr()}:'),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.deviceName,
                    style: TextTheme.of(context)
                        .bodySmall
                        ?.copyWith(color: AppTheme.primaryColor),
                  ),
                ),
              ],
            ),
            Row(
              spacing: 2,
              children: <Widget>[
                Text('${'last_login'.tr()}:'),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    DateFormat('yyyy-MM-dd – kk:mm').format(item.lastLoginTime),
                    style: TextTheme.of(context)
                        .bodySmall
                        ?.copyWith(color: AppTheme.secondaryColor),
                  ),
                ),
              ],
            ),
            // The rest of the info
            Text('${'app_version'.tr()}: ${item.appVersion}'),
            Text('${'device_type'.tr()}: ${item.deviceType}'),
          ],
        ),
      ),
    );
  }
}
