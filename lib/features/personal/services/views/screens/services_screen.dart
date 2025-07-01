import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../widgets/services_page_type_toggle_section.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});
  static const String routeName = '/services';
  @override
  Widget build(BuildContext context) {
    return PersonalScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'services',
                style: Theme.of(context).textTheme.titleLarge,
              ).tr(),
              const SizedBox(height: 8),
              const ServicesPageTypeToggleSection(),
            ],
          ),
        ),
      ),
    );
  }
}
