import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../../../../home/view/enums/counter_offer_enum.dart';
import '../../../../../../../home/view/providers/feed_provider.dart';
import '../../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import 'offer_message_tile_counter_offer_button.dart';

class OfferTileUpdateButons extends StatelessWidget {
  const OfferTileUpdateButons({
    required this.message,
    this.counterBy,
    super.key,
  });

  final MessageEntity message;
  final CounterOfferEnum? counterBy;

  @override
  Widget build(BuildContext context) {
    final FeedProvider pro = Provider.of<FeedProvider>(context, listen: false);
    // If seller countered, buyer only sees accept/reject (no counter)
    final bool showCounterButton = counterBy != CounterOfferEnum.seller;

    return Row(
      spacing: 4,
      children: <Widget>[
        // Decline button
        Expanded(
          child: CustomElevatedButton(
            padding: const EdgeInsets.symmetric(vertical: 4),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Theme.of(context).primaryColor),
            textColor: Theme.of(context).primaryColor,
            textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
            bgColor: Colors.transparent,
            title: 'decline'.tr(),
            isLoading: false,
            onTap: () {
              pro.updateOffer(
                chatId: '',
                context: context,
                offerStatus: 'reject',
                offerId: message.offerDetail!.offerId,
                messageID: message.messageId,
              );
            },
          ),
        ),

        // Counter offer button (hidden when seller countered)
        if (showCounterButton)
          OfferMessageTileCounterOfferButton(message: message),

        // Accept button
        Expanded(
          child: CustomElevatedButton(
            padding: const EdgeInsets.symmetric(vertical: 4),
            borderRadius: BorderRadius.circular(6),
            title: 'accept'.tr(),
            textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
            ),
            isLoading: false,
            onTap: () {
              pro.updateOffer(
                chatId: '',
                context: context,
                offerStatus: 'accept',
                offerId: message.offerDetail!.offerId,
                messageID: message.messageId,
              );
            },
          ),
        ),
      ],
    );
  }
}
