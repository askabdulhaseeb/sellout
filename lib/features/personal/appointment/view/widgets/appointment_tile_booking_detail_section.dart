import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../business/core/data/sources/local_business.dart';
import '../../../../business/core/data/sources/service/local_service.dart';
import '../../../../business/core/domain/entity/business_entity.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../bookings/domain/entity/booking_entity.dart';
import '../providers/appointment_tile_provider.dart';

class AppointmentTileBookingDetailSection extends StatelessWidget {
  const AppointmentTileBookingDetailSection({required this.booking, super.key});
  final BookingEntity booking;

  @override
  Widget build(BuildContext context) {
    final AppointmentTileProvider pro =
        Provider.of<AppointmentTileProvider>(context, listen: false);
    return FutureBuilder<BusinessEntity?>(
      future: LocalBusiness().getBusiness(booking.businessID ?? ''),
      builder: (
        BuildContext context,
        AsyncSnapshot<BusinessEntity?> snapshot,
      ) {
        final BusinessEntity? business = snapshot.data;
        pro.setbusiness(business);
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FutureBuilder<ServiceEntity?>(
                        future:
                            LocalService().getService(booking.serviceID ?? ''),
                        builder: (BuildContext context,
                            AsyncSnapshot<ServiceEntity?> serviceSnap) {
                          final ServiceEntity? service = serviceSnap.data;
                          pro.setService(service);
                          return Text(
                            service?.name ?? 'unknow_service'.tr(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      Text(
                        '${'with'.tr()} ${business?.displayName ?? 'unknow_business'.tr()}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  margin: const EdgeInsets.only(left: 8, top: 4),
                  decoration: BoxDecoration(
                    color: booking.status.bgColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    booking.status.code.tr(),
                    style: TextStyle(
                      fontSize: 12,
                      color: booking.status.color,
                    ),
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }
}
