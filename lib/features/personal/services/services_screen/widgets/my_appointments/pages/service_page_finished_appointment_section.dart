import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../../../../../../core/enums/core/status_type.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../../appointment/view/screens/appointment_tile.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../bookings/data/sources/local_booking.dart';
import '../../../../../bookings/domain/entity/booking_entity.dart';

class ServicePageFinishedAppointmentSection extends StatelessWidget {
  const ServicePageFinishedAppointmentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<BookingEntity>>(
      valueListenable: Hive.box<BookingEntity>(
        AppStrings.localBookingsBox,
      ).listenable(),
      builder: (BuildContext context, Box<BookingEntity> box, _) {
        final List<BookingEntity> allUserBookings = LocalBooking().userBooking(
          LocalAuth.uid ?? '',
        );

        // 🔥 Filter finished appointments — adjust statuses as needed
        final List<BookingEntity> finishedBookings = allUserBookings
            .where(
              (BookingEntity booking) =>
                  booking.status == StatusType.completed &&
                      booking.paymentDetail?.status == StatusType.paid ||
                  booking.status == StatusType.cancelled,
            )
            .toList();
        if (finishedBookings.isEmpty) {
          return Center(child: Text('no_apointment_found'.tr()));
        }
        return ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: finishedBookings.length,
          itemBuilder: (BuildContext context, int index) {
            return AppointmentTile(booking: finishedBookings);
          },
        );
      },
    );
  }
}
