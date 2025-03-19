import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../chats/chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../provider/view_booking_provider.dart';

class BookVisitButton extends StatelessWidget {
  const BookVisitButton({
    this.post,
    super.key,
  });
  final PostEntity? post;

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(builder:
        (BuildContext context, BookingProvider provider, Widget? child) {
      return CustomElevatedButton(
          bgColor: provider.selectedTime != null
              ? AppTheme.primaryColor
              : AppTheme.darkScaffldColor.withAlpha(100),
          title: 'book'.tr(),
          isLoading: provider.isLoading,
          onTap: () {
            provider.setpostId(post!.postID);
            provider.setbusinessId(post!.businessID ?? 'null');
            if (provider.messageentity == null) {
              provider.bookVisit(context);
            } else {
              provider.updateVisit(
                  context: context,
                  visitingId:
                      provider.messageentity?.visitingDetail?.visitingID ?? '',
                  messageId: provider.messageentity!.messageId);
              debugPrint('date${provider.formattedDateTime}');
            }
          });
    });
  }
}
