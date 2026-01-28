// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../../bookings/domain/entity/booking_entity.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../../post/domain/entities/visit/visiting_entity.dart';
import '../provider/booking_provider.dart';

class BookVisitButton extends StatelessWidget {
  const BookVisitButton({
    super.key,
    this.post,
    this.service,
    this.booking,
    this.visit,
  });

  final PostEntity? post;
  final ServiceEntity? service;
  final BookingEntity? booking;
  final VisitingEntity? visit;

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (BuildContext context, BookingProvider provider, Widget? child) {
        // Determine the dynamic button title
        String buttonTitle = 'book'.tr(); // default

        if (post != null && visit == null) {
          buttonTitle = 'book_visit'.tr();
        } else if (post != null && visit != null) {
          buttonTitle = 'update_visit'.tr();
        } else if (service != null && booking == null) {
          buttonTitle = 'book_service'.tr();
        } else if (service != null && booking != null) {
          buttonTitle = 'update_appointment'.tr();
        }

        return CustomElevatedButton(
          bgColor: provider.selectedTime != null
              ? Theme.of(context).primaryColor
              : Theme.of(context).disabledColor,
          title: buttonTitle,
          isLoading: provider.isLoading,
          onTap: () async {
            if (post != null && visit == null) {
              debugPrint('booking visit  button pressed');
              provider.bookVisit(context, post!.postID);
            } else if (post != null && visit != null) {
              debugPrint('updating visit  button pressed');
              provider.updateVisit(
                query: 'date',
                chatID: provider.messageentity?.chatId ?? '',
                context: context,
                visitingId:
                    provider.messageentity?.visitingDetail?.visitingID ?? '',
                messageId: provider.messageentity!.messageId,
              );
            } else if (service != null && booking == null) {
              debugPrint('booking service button pressed');
              provider.bookService(context, service!.serviceID);
            } else if (service != null && booking != null) {
              debugPrint('updating service button pressed');
              provider.updateServiceBooking(context, booking!);
            }
          },
        );
      },
    );
  }
}
