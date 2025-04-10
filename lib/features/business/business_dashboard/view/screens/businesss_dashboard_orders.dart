import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/widgets/scaffold/personal_scaffold.dart';

class BusinessDashboardOrders extends StatelessWidget {
  const BusinessDashboardOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return const PersonalScaffold(
      body: Center(child: Text('orders')),
    );
  }
}
