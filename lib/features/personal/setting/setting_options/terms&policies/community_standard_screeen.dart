import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CommunityStandardsScreen extends StatelessWidget {
  const CommunityStandardsScreen({super.key});
  static const String routeName = '/community_standards';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('community_standards_title'.tr()), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text('community_standards_content'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: ColorScheme.of(context).outline)),
        ),
      ),
    );
  }
}
