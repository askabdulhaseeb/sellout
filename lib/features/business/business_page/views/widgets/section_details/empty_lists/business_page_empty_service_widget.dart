import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/empty_page_widget.dart';

class BusinessPageEmptyServiceWidget extends StatelessWidget {
  const BusinessPageEmptyServiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        EmptyPageWidget(
          icon: Icons.install_desktop_rounded,
          childBelow: const Text('no_services_available').tr(),
        ),
      ],
    );
  }
}
