import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../../bookings/domain/entity/booking_entity.dart';
import '../../../../user/profiles/domain/entities/user_entity.dart';
import '../../../../../../core/extension/datetime_ext.dart';

class AppointmentDescriptionSection extends StatelessWidget {
  const AppointmentDescriptionSection({
    required this.business,
    required this.service,
    required this.user,
    required this.booking,
    super.key,
  });

  final BusinessEntity business;
  final ServiceEntity? service;
  final UserEntity user;
  final BookingEntity booking;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              service?.name ?? '',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              margin: const EdgeInsets.only(left: 6, top: 2),
              decoration: BoxDecoration(
                color: booking.status.bgColor.withValues(alpha: 0.15),
                border: Border.all(color: booking.status.bgColor, width: 0.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                booking.status.code.tr(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: booking.status.color,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                '${'with'.tr()} ${user.displayName}:',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: ColorScheme.of(context).outline),
              ),
            ),
            Text(
              '${booking.bookedAt.timeOnly} - ${booking.endAt.timeOnly}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: ColorScheme.of(context).outline),
            ),
            const Divider(),
          ],
        ),
        const Divider()
      ],
    );
  }
}
