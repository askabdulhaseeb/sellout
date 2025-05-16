// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../features/personal/bookings/domain/entity/booking_entity.dart';
import '../../../../extension/datetime_ext.dart';
import '../../../../extension/int_ext.dart';

class AppointmentTileDatetimeSection extends StatelessWidget {
  const AppointmentTileDatetimeSection({required this.booking, super.key});

  final BookingEntity booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 8),
          SizedBox(
            height: 20,
            width: double.infinity,
            child: FittedBox(
              child: Text(
                booking.bookedAt.monthFullName.toLowerCase().tr(),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Text(
            booking.bookedAt.day.putInStart(sign: '0', length: 2),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 20,
            child: FittedBox(
              child: Text(
                  '${booking.bookedAt.timeOnly} - ${booking.endAt.timeOnly}'),
            ),
          ),
        ],
      ),
    );
  }
}
