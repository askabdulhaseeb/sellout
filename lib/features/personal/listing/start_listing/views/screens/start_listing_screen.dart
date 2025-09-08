import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../../../../../../core/widgets/searchable_textfield.dart';
import '../widgets/start_selling_list.dart';

class StartListingScreen extends StatefulWidget {
  const StartListingScreen({super.key});
  static const String routeName = '/add';

  @override
  State<StartListingScreen> createState() => _StartListingScreenState();
}

class _StartListingScreenState extends State<StartListingScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return PersonalScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            AppBarTitle(
              titleKey: 'start_selling'.tr(),
            ),
            SearchableTextfield(
              hintText: 'search_listing'.tr(),
              onChanged: (String value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
            StartSellingList(searchQuery: searchQuery),
          ],
        ),
      ),
    );
  }
}
