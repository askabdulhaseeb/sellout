import 'package:flutter/material.dart';

import '../../../../../core/widgets/scaffold/personal_scaffold.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});
  static const String routeName = '/services';

  @override
  Widget build(BuildContext context) {
    return const PersonalScaffold(
      body: Center(child: Text('Services Screen')),
    );
  }
}
