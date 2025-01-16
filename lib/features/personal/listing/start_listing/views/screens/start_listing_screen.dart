import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../../../../../../core/widgets/searchable_textfield.dart';
import '../widgets/start_selling_list.dart';

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
                'start_selling'.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SearchableTextfield(
                hintText: 'search_listing'.tr(),
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
