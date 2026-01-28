import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../bookings/domain/entity/booking_entity.dart';
import '../../../../../../core/enums/core/status_type.dart';
import '../../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../../../core/widgets/loaders/loader.dart';
import '../../providers/appointment_tile_provider.dart';

class AppointmentTileUpdateButtonSection extends StatelessWidget {
  const AppointmentTileUpdateButtonSection({required this.booking, super.key});
  final BookingEntity booking;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentTileProvider>(
      builder: (BuildContext context, AppointmentTileProvider pro, _) {
        if (pro.isLoading) return const Loader();

        // COMPLETED BOOKING
        if (booking.isCompleted) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (booking.paymentDetail?.status != StatusType.onHold)
                Column(
                  children: <Widget>[
                    CustomElevatedButton(
                      title: 'book_again'.tr(),
                      isLoading: false,
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      bgColor: Theme.of(context).colorScheme.secondary,
                      onTap: () async =>
                          await pro.onBookAgain(context, booking),
                    ),
                    CustomElevatedButton(
                      title: 'leave_a_review'.tr(),
                      isLoading: false,
                      bgColor: Colors.transparent,
                      border: Border.all(
                        color: Theme.of(context).disabledColor,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      onTap: () async =>
                          await pro.onLeaveReview(context, booking),
                    ),
                  ],
                ),
            ],
          );
        }
        // ACTIVE BOOKING
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CustomElevatedButton(
                      textColor: Theme.of(context).primaryColor,
                      title: 'cancel'.tr(),
                      margin: EdgeInsets.zero,
                      bgColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      border: Border.all(color: Theme.of(context).primaryColor),
                      isLoading: false,
                      onTap: () async => await pro.onCancel(context, booking),
                    ),
                  ),
                ),
                Expanded(
                  child: CustomElevatedButton(
                    title: 'change'.tr(),
                    bgColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    border: Border.all(color: Theme.of(context).disabledColor),
                    margin: EdgeInsets.zero,
                    isLoading: false,
                    onTap: () async {
                      pro.onChange(context, booking);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
