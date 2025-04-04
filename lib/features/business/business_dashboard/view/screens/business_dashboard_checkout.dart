import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/widgets/scaffold/personal_scaffold.dart';

class BusinessDashboardCheckout extends StatelessWidget {
  const BusinessDashboardCheckout({super.key});

  @override
  Widget build(BuildContext context) {
    return const PersonalScaffold(
      body: Center(child: Text('checkout')),
    );
  }
}
