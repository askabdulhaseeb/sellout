import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../../../core/enums/core/status_type.dart';
import '../../../../../appointment/view/screens/appointment_tile.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../bookings/data/sources/local_booking.dart';
import '../../../../../bookings/domain/entity/booking_entity.dart';

class ServicePageUpcomingAppointmentSection extends StatelessWidget {
  const ServicePageUpcomingAppointmentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<BookingEntity>>(
      valueListenable:
          Hive.box<BookingEntity>(LocalBooking.boxTitle).listenable(),
      builder: (BuildContext context, Box<BookingEntity> box, _) {
        final List<BookingEntity> allUserBookings =
            LocalBooking().userBooking(LocalAuth.uid ?? '');
        // 🔥 Filter only pending ones
        final List<BookingEntity> pendingBookings = allUserBookings
            .where(
                (BookingEntity booking) => booking.status == StatusType.pending)
            .toList();
        if (pendingBookings.isEmpty) {
          return Center(child: Text('no_apointment_found'.tr()));
        }
        return ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: pendingBookings.length,
          itemBuilder: (BuildContext context, int index) {
            return AppointmentTile(booking: pendingBookings[index]);
          },
        );
      },
    );
  }
}
