import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/custom_toggle_switch.dart';
import '../enums/services_page_type.dart';
import '../providers/services_page_provider.dart';
import '../screens/pages/service_page_explore_section.dart';
import '../screens/pages/service_page_my_appointment_section.dart';

class ServicesPageTypeToggleSection extends StatelessWidget {
  const ServicesPageTypeToggleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesPageProvider>(
      builder: (BuildContext context, ServicesPageProvider pro, _) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CustomToggleSwitch<ServicesPageType>(
                verticalMargin: 8,
                verticalPadding: 10,
                containerHeight: 40,
                unseletedBorderColor:
                    Theme.of(context).colorScheme.outlineVariant,
                unseletedTextColor: Theme.of(context).colorScheme.onSurface,
                isShaded: false,
                selectedColors: <Color>[
                  Theme.of(context).primaryColor,
                  Theme.of(context).colorScheme.secondary
                ],
                labels: ServicesPageType.values,
                labelStrs: ServicesPageType.values
                    .map((ServicesPageType e) => e.code.tr())
                    .toList(),
                labelText: '',
                initialValue: pro.servicesPageType,
                onToggle: (ServicesPageType value) =>
                    pro.setServicesPageType(value),
              ),
              pro.servicesPageType == ServicesPageType.explore
                  ? const ServicePageExploreSection()
                  : const ServicePageMyAppointmentSection(),
            ],
          ),
        );
      },
    );
  }
}
