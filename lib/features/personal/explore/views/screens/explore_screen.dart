import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/widgets/scaffold/personal_scaffold.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});
  static const String routeName = '/explore';

  @override
  Widget build(BuildContext context) {
    return PersonalScaffold(
      body: Column(
        children: <Widget>[
          const Text('explore').tr(),
        ],
      ),
    );
  }
}
