import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../enums/service_appointment_section_type.dart';
import '../../providers/services_page_provider.dart';
import 'pages/service_page_finished_appointment_section.dart';
import 'pages/service_page_upcoming_appointment_section.dart';

class ServicePageAppointmentTypeSelectionSection extends StatelessWidget {
  const ServicePageAppointmentTypeSelectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesPageProvider>(
        builder: (BuildContext context, ServicesPageProvider pro, _) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _Tap(
                type: ServiceAppointmentSectionType.upcoming,
                isSelected: pro.serviceAppointmentSectionType ==
                    ServiceAppointmentSectionType.upcoming,
                onTap: () => pro.setServiceAppointmentSectionType(
                    ServiceAppointmentSectionType.upcoming),
              ),
              _Tap(
                type: ServiceAppointmentSectionType.finished,
                isSelected: pro.serviceAppointmentSectionType ==
                    ServiceAppointmentSectionType.finished,
                onTap: () => pro.setServiceAppointmentSectionType(
                    ServiceAppointmentSectionType.finished),
              ),
            ],
          ),
          const SizedBox(height: 12),
          pro.serviceAppointmentSectionType ==
                  ServiceAppointmentSectionType.upcoming
              ? const ServicePageUpcomingAppointmentSection()
              : const ServicePageFinishedAppointmentSection(),
        ],
      );
    });
  }
}

class _Tap extends StatelessWidget {
  const _Tap({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });
  final ServiceAppointmentSectionType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = isSelected
        ? Theme.of(context).primaryColor
        : Theme.of(context).disabledColor;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                type.code,
                style: TextStyle(fontWeight: FontWeight.w400, color: color),
              ).tr(),
            ),
            if (isSelected)
              GestureDetector(
                child: Container(
                  height: 1,
                  width: double.infinity,
                  color: color,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
