import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/services_page_provider.dart';
import '../../widgets/my_appointments/service_page_appointment_type_selection_section.dart';

class ServicePageMyAppointmentSection extends StatelessWidget {
  const ServicePageMyAppointmentSection({super.key});
  @override
  Widget build(BuildContext context) {
    final ServicesPageProvider pro =
        Provider.of<ServicesPageProvider>(context, listen: false);
    pro.getBookings();
    return const Column(
      children: <Widget>[
        ServicePageAppointmentTypeSelectionSection(),
      ],
    );
  }
}
