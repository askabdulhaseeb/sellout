import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../features/personal/bookings/domain/entity/booking_entity.dart';
import '../../../../features/personal/user/profiles/data/sources/local/local_user.dart';
import '../../profile_photo.dart';

class AppointmentTileUserInfoSection extends StatelessWidget {
  const AppointmentTileUserInfoSection({required this.booking, super.key});
  final BookingEntity booking;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: FutureBuilder<UserEntity?>(
        future: LocalUser().user(
            booking.amICustomer ? booking.employeeID : booking.customerID),
        builder: (
          BuildContext context,
          AsyncSnapshot<UserEntity?> snapshot,
        ) {
          final UserEntity? user = snapshot.data;
          return Row(
            children: <Widget>[
              ProfilePhoto(
                url: user?.profilePhotoURL,
                placeholder: user?.displayName ?? '',
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user?.displayName ?? 'na'.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${user?.address.first.townCity}/${user?.address.first.country}',
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
