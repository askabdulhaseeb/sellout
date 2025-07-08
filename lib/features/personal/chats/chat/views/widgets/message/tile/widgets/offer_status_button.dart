import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../post/feed/views/enums/offer_status_enum.dart';
import '../../../../../../../post/feed/views/providers/feed_provider.dart';
import '../../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import 'counter_offer_bottomsheet.dart';

class OfferStatusButtons extends HookWidget {
  const OfferStatusButtons({
    required this.message,
    super.key,
  });
  final MessageEntity message;
  void showOfferBottomSheet(BuildContext context, MessageEntity message) {
    showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CounterBottomSheet(message: message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (BuildContext context, FeedProvider pro, _) {
        return Row(
          spacing: 4,
          children: <Widget>[
            // Decline button
            Expanded(
              child: CustomElevatedButton(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Theme.of(context).primaryColor),
                textColor: Theme.of(context).primaryColor,
                bgColor: Colors.transparent,
                title: 'decline'.tr(),
                isLoading: false,
                onTap: () {
                  pro.updateOffer(
                    chatId: message.chatId,
                    context: context,
                    offerStatus: OfferStatus.reject.value,
                    offerId: message.offerDetail!.offerId,
                    messageID: message.messageId,
                  );
                },
              ),
            ),
            Expanded(
              child: CustomElevatedButton(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.transparent),
                textColor: Theme.of(context).primaryColor,
                bgColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                title: 'counter'.tr(),
                isLoading: false,
                onTap: () {
                  showOfferBottomSheet(context, message);
                },
              ),
            ),
            // Accept button
            Expanded(
              child: CustomElevatedButton(
                borderRadius: BorderRadius.circular(10),
                title: 'accept'.tr(),
                isLoading: false,
                onTap: () {
                  pro.updateOffer(
                    chatId: message.chatId,
                    context: context,
                    offerStatus: OfferStatus.accept.name,
                    offerId: message.offerDetail!.offerId,
                    messageID: message.messageId,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
