import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../bookings/domain/entity/booking_entity.dart';
import '../../../providers/services_page_provider.dart';
import '../../../../../../../core/widgets/appointment/appointment_tile.dart';

class ServicePageFinishedAppointmentSection extends StatelessWidget {
  const ServicePageFinishedAppointmentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesPageProvider>(
      builder: (BuildContext context, ServicesPageProvider pro, _) {
        return FutureBuilder<List<BookingEntity>>(
          future: pro.getBookings(),
          initialData: pro.bookings,
          builder: (
            BuildContext context,
            AsyncSnapshot<List<BookingEntity>> snapshot,
          ) {
            final List<BookingEntity> bookings = pro.bookings;
            return bookings.isEmpty
                ? Center(child: Text('no_apointment_found'.tr()))
                : ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: bookings.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AppointmentTile(booking: bookings[index]);
                    },
                  );
          },
        );
      },
    );
  }
}
