import 'package:flutter/material.dart';

import '../../../features/personal/bookings/domain/entity/booking_entity.dart';
import 'widgets/appointment_tile_booking_detail_section.dart';
import 'widgets/appointment_tile_button_section.dart';
import 'widgets/appointment_tile_datetime_section.dart';
import 'widgets/appointment_tile_user_info_section.dart';

class AppointmentTile extends StatelessWidget {
  const AppointmentTile({required this.booking, super.key});
  final BookingEntity booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AppointmentTileBookingDetailSection(booking: booking),
                    AppointmentTileUserInfoSection(booking: booking),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AppointmentTileDatetimeSection(booking: booking),
            ],
          ),
          AppointmentTileButtonSection(booking: booking),
        ],
      ),
    );
  }
}
