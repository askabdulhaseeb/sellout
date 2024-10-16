import 'package:flutter/material.dart';

import '../../../../../core/widgets/scaffold/personal_scaffold.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return const PersonalScaffold(
      body: Center(child: Text('Profile Screen')),
    );
  }
}
