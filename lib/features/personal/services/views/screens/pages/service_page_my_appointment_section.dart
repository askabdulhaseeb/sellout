import 'package:flutter/material.dart';

import '../../widgets/my_appointments/service_page_appointment_type_selection_section.dart';

class ServicePageMyAppointmentSection extends StatelessWidget {
  const ServicePageMyAppointmentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        ServicePageAppointmentTypeSelectionSection(),
      ],
    );
  }
}
