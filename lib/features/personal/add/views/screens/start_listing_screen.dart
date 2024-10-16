import 'package:flutter/material.dart';

import '../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../../../../../core/widgets/searchable_textfield.dart';
import '../widgets/start_listing/start_selling_list.dart';

class StartListingScreen extends StatelessWidget {
  const StartListingScreen({super.key});
  static const String routeName = '/add';

  @override
  Widget build(BuildContext context) {
    return PersonalScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              Text(
                'start-selling'.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SearchableTextfield(
                hintText: 'search-listing'.tr(),
                onChanged: (String p0) {},
              ),
              const StartSellingList(),
            ],
          ),
        ),
      ),
    );
  }
}
