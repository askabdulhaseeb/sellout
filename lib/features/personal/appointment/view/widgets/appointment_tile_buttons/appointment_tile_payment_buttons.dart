import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/enums/core/status_type.dart';
import '../../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../bookings/domain/entity/booking_entity.dart';
import '../../providers/appointment_tile_provider.dart';

class AppointmentTilePaymentButtons extends StatelessWidget {
  const AppointmentTilePaymentButtons({required this.booking, super.key});
  final List<BookingEntity> booking;

  @override
  Widget build(BuildContext context) {
    final AppointmentTileProvider pro = Provider.of<AppointmentTileProvider>(
      context,
      listen: false,
    );
    final bool allCompleted = booking.every((BookingEntity b) => b.isCompleted);
    final bool allPending = booking.every(
      (BookingEntity b) => b.paymentDetail?.status == StatusType.pending,
    );
    final bool allOnHold = booking.every(
      (BookingEntity b) => b.paymentDetail?.status == StatusType.onHold,
    );
    if (allCompleted && allOnHold) {
      return CustomElevatedButton(
        title: 'release_payment'.tr(),
        isLoading: false,
        padding: const EdgeInsets.symmetric(vertical: 6),
        onTap: () async {
          for (final BookingEntity b in booking) {
            await pro.releasePayment(b.paymentDetail?.transactionID);
          }
        },
      );
    }
    if (!allCompleted && allPending) {
      return CustomElevatedButton(
        title: 'pay_now'.tr(),
        isLoading: false,
        padding: const EdgeInsets.symmetric(vertical: 6),
        onTap: () async {
          for (final BookingEntity b in booking) {
            await pro.onPayNow(context, b);
          }
        },
      );
    }
    if (!allCompleted && allOnHold) {
      return CustomElevatedButton(
        isDisable: true,
        title: 'paid'.tr(),
        isLoading: false,
        padding: const EdgeInsets.symmetric(vertical: 6),
        onTap: () async {
          for (final BookingEntity b in booking) {
            await pro.onPayNow(context, b);
          }
        },
      );
    }
    return const SizedBox.shrink();
  }
}
