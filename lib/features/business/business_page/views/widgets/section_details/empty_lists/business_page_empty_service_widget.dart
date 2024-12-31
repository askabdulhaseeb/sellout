import 'package:flutter/material.dart';

import '../../../../../../../core/widgets/scaffold/personal_scaffold.dart';

class BusinessPageEmptyServiceWidget extends StatelessWidget {
  const BusinessPageEmptyServiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Opacity(
        opacity: 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.install_desktop_rounded, size: 100),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: FittedBox(
                child: const Text('no-services-available').tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
