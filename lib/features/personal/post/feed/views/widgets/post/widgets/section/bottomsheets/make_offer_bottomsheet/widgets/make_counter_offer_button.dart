import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../providers/feed_provider.dart';
import '../../../../../../../../../../chats/chat_dashboard/domain/entities/messages/message_entity.dart';

class MakeCOunterOfferButton extends StatelessWidget {
  const MakeCOunterOfferButton({
    required this.message,
    required this.counterOfferAmount,
    required this.counterQuantity,
    required this.currency,
    super.key,
  });

  final MessageEntity message;
  final int counterOfferAmount;
  final int counterQuantity;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (BuildContext context, FeedProvider pro, Widget? child) {
        return CustomElevatedButton(
          onTap: () {
            pro.updateOffer(
              currency: currency,
              counterOffer: true,
              chatId: message.chatId,
              quantity: counterQuantity,
              context: context,
              offerId: message.offerDetail!.offerId,
              messageID: message.messageId,
              offerAmount: counterOfferAmount,
            );
            Navigator.pop(context);
          },
          title: 'counter_offer'.tr(),
          isLoading: false,
        );
      },
    );
  }
}
