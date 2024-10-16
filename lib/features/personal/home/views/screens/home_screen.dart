import 'package:flutter/material.dart';

import '../../../../../core/widgets/scaffold/personal_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const String routeName = '/feed';

  @override
  Widget build(BuildContext context) {
    return const PersonalScaffold(
      body: Center(child: Text('Home Screen')),
    );
  }
}
