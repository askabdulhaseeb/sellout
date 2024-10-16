import 'package:flutter/material.dart';

import '../../../../../core/widgets/scaffold/personal_scaffold.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});
  static const String routeName = '/explore';

  @override
  Widget build(BuildContext context) {
    return const PersonalScaffold(
      body: Center(child: Text('Explore Screen')),
    );
  }
}
