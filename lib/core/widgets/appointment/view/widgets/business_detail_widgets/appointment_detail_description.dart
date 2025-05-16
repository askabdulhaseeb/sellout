import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../features/business/core/domain/entity/business_entity.dart';
import '../../../../../../features/business/core/domain/entity/service/service_entity.dart';
import '../../../../../../features/personal/bookings/domain/entity/booking_entity.dart';
import '../../../../../../features/personal/user/profiles/domain/entities/user_entity.dart';
import '../../../../../extension/datetime_ext.dart';

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
        Text(
          business.displayName ?? '',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        const SizedBox(
          height: 6,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              service?.name ?? '',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              service?.price.toString() ?? '',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
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
