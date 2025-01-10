import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/domain/entity/business_entity.dart';
import '../service/business_page_service_filter_section.dart';

class BusinessPageEmptyServiceWidget extends StatelessWidget {
  const BusinessPageEmptyServiceWidget({required this.business, super.key});
  final BusinessEntity business;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        BusinessPageServiceFilterSection(business: business),
        SizedBox(
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
        ),
      ],
    );
  }
}
