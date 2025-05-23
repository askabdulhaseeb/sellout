// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../provider/visiting_provider.dart';

class BookVisitButton extends StatelessWidget {
  const BookVisitButton({
    super.key,
    this.post,
    this.service,
  });
  final PostEntity? post;
  final ServiceEntity? service;

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(builder:
        (BuildContext context, BookingProvider provider, Widget? child) {
      return CustomElevatedButton(
          bgColor: provider.selectedTime != null
              ? Theme.of(context).primaryColor
              : Theme.of(context).cardColor,
          title: 'book'.tr(),
          isLoading: provider.isLoading,
          onTap: () {
            if (post != null) {
              if (provider.messageentity == null) {
                provider.bookVisit(context, post!.postID);
              } else {
                provider.updateVisit(
                    chatID: provider.messageentity?.chatId ?? '',
                    context: context,
                    visitingId:
                        provider.messageentity?.visitingDetail?.visitingID ??
                            '',
                    messageId: provider.messageentity!.messageId);
              }
            } else if (service != null) {
              provider.bookService(
                  context, service!.serviceID, service!.businessID);
            } else {
              debugPrint('both null');
            }
          });
    });
  }
}
