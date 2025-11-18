// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../bookings/domain/entity/booking_entity.dart';
import '../../../../../core/extension/datetime_ext.dart';
import '../../../../../core/extension/int_ext.dart';

class AppointmentTileDatetimeSection extends StatelessWidget {
  const AppointmentTileDatetimeSection({required this.booking, super.key});
  final BookingEntity booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            booking.bookedAt.monthFullName.toLowerCase().tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 9,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            booking.bookedAt.day.putInStart(sign: '0', length: 2),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${booking.bookedAt.timeOnly}–${booking.endAt.timeOnly}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 9),
          ),
        ],
      ),
    );
  }
}
