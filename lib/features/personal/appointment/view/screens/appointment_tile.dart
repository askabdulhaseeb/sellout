import 'package:flutter/material.dart';
import '../../../bookings/domain/entity/booking_entity.dart';
import '../widgets/appointment_tile_booking_detail_section.dart';
import '../widgets/appointment_tile_buttons/appointment_tile_payment_buttons.dart';
import '../widgets/appointment_tile_buttons/appointment_tile_update_button_section.dart';
import '../widgets/appointment_tile_datetime_section.dart';
import '../widgets/appointment_tile_business_info_section.dart';
import 'appointment_detail_screen.dart';

class AppointmentTile extends StatelessWidget {
  const AppointmentTile({required this.booking, super.key});
  final List<BookingEntity> booking;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<AppointmentDetailScreen>(
            builder: (BuildContext context) => AppointmentDetailScreen(
              booking: booking.first,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border:
              Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppointmentTileBusienssInfoSection(booking: booking.first),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: booking.map((BookingEntity b) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: AppointmentTileBookingDetailSection(booking: b),
                      ),
                      const SizedBox(width: 8),
                      AppointmentTileDatetimeSection(booking: b),
                    ],
                  ),
                );
              }).toList(),
            ),
            if (booking.length == 1)
              AppointmentTileUpdateButtonSection(booking: booking.first),
            AppointmentTilePaymentButtons(booking: booking),
          ],
        ),
      ),
    );
  }
}
