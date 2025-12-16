import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../post/feed/views/providers/feed_provider.dart';
import '../../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import 'offer_message_tile_counter_offer_button.dart';

class OfferTileUpdateButons extends StatelessWidget {
  const OfferTileUpdateButons({
    required this.message,
    super.key,
  });

  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    final FeedProvider pro = Provider.of<FeedProvider>(context, listen: false);
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

        // Counter offer button
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
