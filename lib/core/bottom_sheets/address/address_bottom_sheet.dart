import 'package:flutter/material.dart';

import '../../widgets/scaffold/personal_scaffold.dart';

class AddressBottomSheet extends StatelessWidget {
  const AddressBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 24),
        const Text('address').tr(),
        const SizedBox(height: 24),
      ],
    );
  }
}
