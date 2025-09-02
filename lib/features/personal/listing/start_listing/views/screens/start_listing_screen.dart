import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 12),
              Text(
                'start_selling'.tr(),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w500, fontSize: 18),
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
      ),
    );
  }
}
