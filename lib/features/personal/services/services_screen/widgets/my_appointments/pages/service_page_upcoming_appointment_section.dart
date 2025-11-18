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
        // 1️⃣ All user bookings
        final List<BookingEntity> allUserBookings =
            LocalBooking().userBooking(LocalAuth.uid ?? '');
        // 2️⃣ Filter pending + accepted
        final List<BookingEntity> pendingBookings = allUserBookings
            .where((BookingEntity booking) =>
                booking.status == StatusType.pending ||
                booking.status == StatusType.accepted ||
                booking.status == StatusType.inprogress ||
                (booking.status == StatusType.completed &&
                    booking.paymentDetail?.status == StatusType.onHold))
            .toList();
        if (pendingBookings.isEmpty) {
          return Center(child: Text('no_apointment_found'.tr()));
        }
        // 3️⃣ Group by trackingID
        final Map<String, List<BookingEntity>> grouped =
            <String, List<BookingEntity>>{};
        for (final BookingEntity booking in pendingBookings) {
          grouped
              .putIfAbsent(booking.trackingID ?? '', () => <BookingEntity>[])
              .add(booking);
        }

        // 4️⃣ Convert to list for ListView.builder
        final List<MapEntry<String, List<BookingEntity>>> groupedEntries =
            grouped.entries.toList();

        return ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: groupedEntries.length,
          itemBuilder: (BuildContext context, int index) {
            // final String trackingID = groupedEntries[index].key;
            final List<BookingEntity> groupedBookings =
                groupedEntries[index].value;

            // 📝 Pass grouped bookings or just the trackingID to your tile
            return AppointmentTile(
              booking: groupedBookings,
            );
          },
        );
      },
    );
  }
}
