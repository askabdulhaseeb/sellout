import 'package:flutter/material.dart';

import '../../../features/personal/auth/signin/data/sources/local/local_auth.dart';
import 'app_bar/personal_app_bar.dart';
import 'bottom_bar/business_bottom_nav_bar.dart';
import 'bottom_bar/personal_bottom_nav_bar.dart';

// export 'package:easy_localization/easy_localization.dart';

class PersonalScaffold extends StatelessWidget {
  const PersonalScaffold({
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    super.key,
  });
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? personalAppbar(context),
      body: body,
      bottomNavigationBar: LocalAuth.currentUser?.logindetail.type == 'business'
          ? const BusinessBottomNavBar()
          : const PersonalBottomNavBar(),
    );
  }
}
