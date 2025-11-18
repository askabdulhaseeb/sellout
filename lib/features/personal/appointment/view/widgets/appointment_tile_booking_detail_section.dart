import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../business/core/data/sources/service/local_service.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../bookings/domain/entity/booking_entity.dart';
import '../../../user/profiles/data/sources/local/local_user.dart';
import '../providers/appointment_tile_provider.dart';

class AppointmentTileBookingDetailSection extends StatelessWidget {
  const AppointmentTileBookingDetailSection({required this.booking, super.key});
  final BookingEntity booking;

  @override
  Widget build(BuildContext context) {
    final AppointmentTileProvider pro =
        Provider.of<AppointmentTileProvider>(context, listen: false);

    return FutureBuilder<UserEntity?>(
      future: LocalUser().user(booking.employeeID),
      builder: (BuildContext context, AsyncSnapshot<UserEntity?> snapshot) {
        final UserEntity? user = snapshot.data;
        debugPrint(booking.bookingID);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FutureBuilder<ServiceEntity?>(
                    future: LocalService().getService(booking.serviceID ?? ''),
                    builder: (BuildContext context,
                        AsyncSnapshot<ServiceEntity?> serviceSnap) {
                      final ServiceEntity? service = serviceSnap.data;
                      pro.setService(service);
                      return Text(
                        service?.name ?? 'unknow_service'.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      );
                    },
                  ),
                  Text(
                    '${'with'.tr()} ${user?.displayName ?? 'na'.tr()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              margin: const EdgeInsets.only(left: 6, top: 2),
              decoration: BoxDecoration(
                color: booking.status.bgColor.withOpacity(0.15),
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
        );
      },
    );
  }
}
