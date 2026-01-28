import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../business/core/data/sources/local_business.dart';
import '../../../../business/core/domain/entity/business_entity.dart';
import '../../../bookings/domain/entity/booking_entity.dart';
import '../../../../../core/widgets/media/profile_photo.dart';

class AppointmentTileBusienssInfoSection extends StatelessWidget {
  const AppointmentTileBusienssInfoSection({required this.booking, super.key});
  final BookingEntity booking;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: FutureBuilder<BusinessEntity?>(
        future: LocalBusiness().getBusiness(booking.businessID ?? ''),
        builder: (BuildContext context, AsyncSnapshot<BusinessEntity?> snapshot) {
          final BusinessEntity? business = snapshot.data;
          // if (user != null) {
          //   WidgetsBinding.instance.addPostFrameCallback((_) {
          //     context.read<AppointmentTileProvider>().setUser(user);
          //   });
          // }
          return Row(
            children: <Widget>[
              ProfilePhoto(
                url: business?.logo?.url ?? '',
                placeholder: business?.displayName ?? '',
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      business?.displayName ?? 'na'.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (business != null)
                      Text(
                        '${business.address?.firstAddress}/${business.address?.city}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
